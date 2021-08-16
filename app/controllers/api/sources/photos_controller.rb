class Api::Sources::PhotosController < ApplicationController

  def index
    source = find_source
    photos = source.photos.order_by_date.includes(:source_joins, :sources)

    render json: paginate(photos)
  end

  def upload_spec
    source = find_source
    upload_spec = UploadSpec.(record: source.photos.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    source = find_source
    photo = source.photos.build(photo_params)
    Source::Manage.(model: photo, urls: params[:sources])

    if source.save
      render json: photo
    else
      head 422
    end
  end

  def update
    source = find_source
    photo = find_photo(source)

    photo.assign_attributes(photo_params)
    Source::Manage.(model: photo, urls: params[:sources])

    if photo.save
      render json: photo
    else
      head 422
    end
  end

  def destroy
    source = find_source

    photo_join = source.photo_joins.where(photo_id: params[:id]).first
    photo_join.soft_delete if photo_join

    head 200
  end

  private

  def photo_params
    params.permit(:file, :description)
  end

  def find_source
    Source.find(params[:source_id])
  end

  def find_photo(source)
    source.photos.find(params[:id])
  end

end
