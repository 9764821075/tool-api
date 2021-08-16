class OrganizationIndexSerializer < ApplicationSerializer
  attributes :id, :name, :ancestry

  attribute :resource do
    "organizations"
  end

  attribute :primaryPhotoSrc do
    logo = object.logo
    attachment_path(object.logo, :file, :fill, 60, 60) if logo
  end
end
