class OrganizationActivity < ApplicationRecord

  soft_deleteable

  belongs_to :activity
  belongs_to :organization

  validates :activity_id, presence: true
  validates :organization_id, presence: true

  validates :role, length: { maximum: 250 }

end

# == Schema Information
#
# Table name: organization_activities
#
#  id              :uuid             not null, primary key
#  deleted         :boolean          default(FALSE)
#  role            :string
#  activity_id     :uuid
#  organization_id :uuid
#
# Indexes
#
#  index_organization_activities_on_activity_id      (activity_id)
#  index_organization_activities_on_organization_id  (organization_id)
#
