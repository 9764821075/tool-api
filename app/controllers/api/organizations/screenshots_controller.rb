class Api::Organizations::ScreenshotsController < ApplicationController

  def index
    organization = find_organization
    screenshots = organization.screenshots.order_by_date.includes(:source_joins, :sources)

    render json: paginate(screenshots)
  end

  def upload_spec
    organization = find_organization
    upload_spec = UploadSpec.(record: organization.screenshots.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    organization = find_organization
    screenshot = organization.screenshots.build(screenshot_params)
    Source::Manage.(model: screenshot, urls: params[:sources])

    if organization.save
      render json: screenshot
    else
      head 422
    end
  end

  def update
    organization = find_organization
    screenshot = find_screenshot(organization)

    screenshot.assign_attributes(screenshot_params)
    Source::Manage.(model: screenshot, urls: params[:sources])

    if screenshot.save
      render json: screenshot
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    screenshot_join = organization.screenshot_joins.where(screenshot_id: params[:id]).first
    screenshot_join.soft_delete if screenshot_join

    head 200
  end

  private

  def screenshot_params
    params.permit(:file, :description)
  end

  def find_organization
    Organization.find(params[:organization_id])
  end

  def find_screenshot(organization)
    organization.screenshots.find(params[:id])
  end
end
