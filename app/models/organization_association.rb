class OrganizationAssociation < ApplicationRecord
  include SinceUntil

  auto_strip_attributes :position

  soft_deleteable

  belongs_to :organization
  belongs_to :person

  validates :organization_id, presence: true
  validates :person_id, presence: true

  validates :position, length: { maximum: 250 }

  def ongoing?
    return true if until_year.blank?

    until_date = Date.new(until_year, until_month || 1, 1)
    until_date >= Time.zone.now
  end

end

# == Schema Information
#
# Table name: organization_associations
#
#  id              :uuid             not null, primary key
#  deleted         :boolean          default(FALSE)
#  position        :string
#  since_month     :integer
#  since_year      :integer
#  until_month     :integer
#  until_year      :integer
#  organization_id :uuid
#  person_id       :uuid
#
# Indexes
#
#  index_organization_associations_on_organization_id  (organization_id)
#  index_organization_associations_on_person_id        (person_id)
#
