class OrganizationActivitySerializer < ApplicationSerializer
  attributes :id, :role,
             :organization_id, :activity_id

  belongs_to :activity
  belongs_to :organization
end
