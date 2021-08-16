class ActivityIndexSerializer < ApplicationSerializer
  attributes :id, :name, :date

  attribute :resource do
    "activities"
  end

  attribute :location do
    {
      name: object.location,
      city: object.city,
    }
  end

  attribute :primaryPhotoSrc do
    primary_photo = object.primary_photo
    attachment_path(object.primary_photo, :file, :fill, 544, 362) if primary_photo
  end
end
