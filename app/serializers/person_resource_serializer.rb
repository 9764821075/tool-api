class PersonResourceSerializer < ApplicationSerializer
  attributes :id, :name

  attribute :resource do
    "people"
  end

  attribute :image do
    primary_photo = object.primary_photo
    attachment_path(object.primary_photo, :file, :fill, 544, 362) if primary_photo
  end
end
