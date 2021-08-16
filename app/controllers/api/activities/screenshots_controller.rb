class Api::Activities::ScreenshotsController < ApplicationController

  def index
    activity = find_activity
    screenshots = activity.screenshots.order_by_date.includes(:source_joins, :sources)

    render json: paginate(screenshots)
  end

  def upload_spec
    activity = find_activity
    upload_spec = UploadSpec.(record: activity.screenshots.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    activity = find_activity
    screenshot = activity.screenshots.build(screenshot_params)
    Source::Manage.(model: screenshot, urls: params[:sources])

    if activity.save
      render json: screenshot
    else
      head 422
    end
  end

  def update
    activity = find_activity
    screenshot = find_screenshot(activity)

    screenshot.assign_attributes(screenshot_params)
    Source::Manage.(model: screenshot, urls: params[:sources])

    if screenshot.save
      render json: screenshot
    else
      head 422
    end
  end

  def destroy
    activity = find_activity

    screenshot_join = activity.screenshot_joins.where(screenshot_id: params[:id]).first
    screenshot_join.soft_delete if screenshot_join

    head 200
  end

  private

  def screenshot_params
    params.permit(:file, :description)
  end

  def find_activity
    Activity.find(params[:activity_id])
  end

  def find_screenshot(activity)
    activity.screenshots.find(params[:id])
  end
end
