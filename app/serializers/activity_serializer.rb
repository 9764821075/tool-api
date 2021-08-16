class ActivitySerializer < ApplicationSerializer
  attributes :id, :name, :date, :attendance,
             :location, :zip_code, :city, :country

  attribute :resource do
    object.model_name.collection
  end

  attribute :organization_ids do
    object.organizations.map(&:id).uniq
  end

  attribute :primary_photo_preview_src do
    primary_photo = object.primary_photo
    attachment_path(object.primary_photo, :file, :fill, 544, 362) if primary_photo
  end

  attribute :primary_photo_small_src do
    primary_photo = object.primary_photo
    attachment_path(object.primary_photo, :file, :fill, 40, 40) if primary_photo
  end
end
