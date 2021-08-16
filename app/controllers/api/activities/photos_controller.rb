class Api::Activities::PhotosController < ApplicationController

  def index
    activity = find_activity
    photos = activity.photos.order_by_date.includes(:source_joins, :sources, tags: [:person])

    render json: paginate(photos)
  end

  def upload_spec
    activity = find_activity
    upload_spec = UploadSpec.(record: activity.photos.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    activity = find_activity
    photo = activity.photos.build(photo_params)
    Source::Manage.(model: photo, urls: params[:sources])

    if activity.save
      render json: photo
    else
      head 422
    end
  end

  def update
    activity = find_activity
    photo = find_photo(activity)

    photo.assign_attributes(photo_params)
    Source::Manage.(model: photo, urls: params[:sources])

    if photo.save
      render json: photo
    else
      head 422
    end
  end

  def destroy
    activity = find_activity

    photo_join = activity.photo_joins.where(photo_id: params[:id]).first
    photo_join.soft_delete if photo_join

    head 200
  end

  private

  def photo_params
    params.permit(:file, :description)
  end

  def find_activity
    Activity.find(params[:activity_id])
  end

  def find_photo(activity)
    activity.photos.find(params[:id])
  end

end
