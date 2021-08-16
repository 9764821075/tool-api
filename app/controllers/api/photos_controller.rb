class Api::PhotosController < ApplicationController

  def tag
    tag_id = params[:tag_id]

    photo_tag = if tag_id.present?
      PhotoTag.find(tag_id)
    else
      PhotoTag.new(photo_id: params[:id])
    end

    photo_tag.assign_attributes(photo_tag_params)

    if photo_tag.save
      render json: photo_tag
    else
      head 422
    end
  end

  def destroy_tag
    photo_tag = PhotoTag.find(params[:tag_id])

    if photo_tag.soft_delete
      head 200
    else
      head 422
    end
  end

  private

  def photo_tag_params
    params.permit(:top, :left, :width, :height, person: [:id])
          .tap { |p| p[:person_id] = p[:person][:id]; p.delete(:person) }
  end

end
