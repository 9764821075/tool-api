class OrganizationResourceSerializer < ApplicationSerializer
  attributes :id, :name

  attribute :resource do
    "organizations"
  end

  attribute :image do
    logo = object.logo
    attachment_path(object.logo, :file, :fill, 544, 362) if logo
  end
end
