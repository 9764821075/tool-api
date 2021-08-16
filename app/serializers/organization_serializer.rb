class OrganizationSerializer < ApplicationSerializer
  attributes :id, :name, :shortname, :ancestry

  attribute :resource do
    object.model_name.collection
  end

  attribute :primary_photo_preview_src do
    logo = object.logo
    attachment_path(object.logo, :file, :fill, 60, 60) if logo
  end

  attribute :primary_photo_small_src do
    logo = object.logo
    attachment_path(object.logo, :file, :fill, 40, 40) if logo
  end
end
