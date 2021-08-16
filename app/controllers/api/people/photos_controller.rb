class Api::People::PhotosController < ApplicationController

  def index
    person = find_person
    photos = person.photos.order_by_date.includes(:source_joins, :sources, tags: [:person])

    render json: paginate(photos)
  end

  def upload_spec
    person = find_person
    upload_spec = UploadSpec.(record: person.photos.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    person = find_person
    photo = person.photos.build(photo_params)
    Source::Manage.(model: photo, urls: params[:sources])

    if person.save
      render json: photo
    else
      head 422
    end
  end

  def update
    person = find_person
    photo = find_photo(person)

    photo.assign_attributes(photo_params)
    Source::Manage.(model: photo, urls: params[:sources])

    if photo.save
      render json: photo
    else
      head 422
    end
  end

  def destroy
    person = find_person

    photo_join = person.photo_joins.where(photo_id: params[:id]).first
    photo_join.soft_delete if photo_join

    head 200
  end

  private

  def photo_params
    params.permit(:file, :description)
  end

  def find_person
    Person.find(params[:person_id])
  end

  def find_photo(person)
    person.photos.find(params[:id])
  end

end
