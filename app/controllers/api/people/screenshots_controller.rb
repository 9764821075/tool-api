class Api::People::ScreenshotsController < ApplicationController

  def index
    person = find_person
    screenshots = person.screenshots.order_by_date.includes(:source_joins, :sources)

    render json: paginate(screenshots)
  end

  def upload_spec
    person = find_person
    upload_spec = UploadSpec.(record: person.screenshots.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    person = find_person
    screenshot = person.screenshots.build(screenshot_params)
    Source::Manage.(model: screenshot, urls: params[:sources])

    if person.save
      render json: screenshot
    else
      head 422
    end
  end

  def update
    person = find_person
    screenshot = find_screenshot(person)

    screenshot.assign_attributes(screenshot_params)
    Source::Manage.(model: screenshot, urls: params[:sources])

    if screenshot.save
      render json: screenshot
    else
      head 422
    end
  end

  def destroy
    person = find_person

    screenshot_join = person.screenshot_joins.where(screenshot_id: params[:id]).first
    screenshot_join.soft_delete if screenshot_join

    head 200
  end

  private

  def screenshot_params
    params.permit(:file, :description)
  end

  def find_person
    Person.find(params[:person_id])
  end

  def find_screenshot(person)
    person.screenshots.find(params[:id])
  end
end
