class OrganizationAssociationSerializer < ApplicationSerializer
  attributes :id, :position, :since, :until

  belongs_to :organization, serializer: OrganizationResourceSerializer
  belongs_to :person, serializer: PersonResourceSerializer
end
