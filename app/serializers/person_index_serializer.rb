class PersonIndexSerializer < ApplicationSerializer
  attributes :id, :name

  attribute :resource do
    "people"
  end

  attribute :organizations do
    object.organizations.order_by_name.select(:id, :name).uniq(&:id).map { |o| {
      id: o.id,
      name: o.name,
      resource: "groups",
    }}
  end

  attribute :primaryPhotoSrc do
    primary_photo = object.primary_photo
    attachment_path(object.primary_photo, :file, :fill, 544, 680) if primary_photo
  end
end
