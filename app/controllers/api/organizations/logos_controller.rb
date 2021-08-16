class Api::Organizations::LogosController < ApplicationController

  def show
    Refile.host = request.url

    organization = find_organization
    logo = organization.logo

    if logo
      render json: logo
    else
      head 404
    end
  end

  def upload_spec
    upload_spec = UploadSpec.(record: Logo.new, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    organization = find_organization

    organization.logo.soft_delete if organization.logo
    logo = organization.build_logo(logo_params)

    if logo.save
      render json: logo
    else
      head 422
    end
  end

  private

  def logo_params
    params.permit(:file)
  end

  def find_organization
    Organization.find(params[:organization_id] || params[:id])
  end

end
