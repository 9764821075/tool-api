class Api::Organizations::PhotosController < ApplicationController

  def index
    organization = find_organization
    photos = organization.photos.order_by_date.includes(:source_joins, :sources)

    render json: paginate(photos)
  end

  def upload_spec
    organization = find_organization
    upload_spec = UploadSpec.(record: organization.photos.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    organization = find_organization
    photo = organization.photos.build(photo_params)
    Source::Manage.(model: photo, urls: params[:sources])

    if organization.save
      render json: photo
    else
      head 422
    end
  end

  def update
    organization = find_organization
    photo = find_photo(organization)

    photo.assign_attributes(photo_params)
    Source::Manage.(model: photo, urls: params[:sources])

    if photo.save
      render json: photo
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    photo_join = organization.photo_joins.where(photo_id: params[:id]).first
    photo_join.soft_delete if photo_join

    head 200
  end

  private

  def photo_params
    params.permit(:file, :description)
  end

  def find_organization
    Organization.find(params[:organization_id])
  end

  def find_photo(organization)
    organization.photos.find(params[:id])
  end

end
