class OrganizationAddress < ApplicationRecord
  include SinceUntil

  soft_deleteable has_many: [
    :source_joins,
  ]

  belongs_to :organization
  belongs_to :address, autosave: true

  has_many :source_joins, as: :sourceable, autosave: true
  has_many :sources, through: :source_joins

  validates_associated :address

end

# == Schema Information
#
# Table name: organization_addresses
#
#  id              :uuid             not null, primary key
#  deleted         :boolean          default(FALSE)
#  since_month     :integer
#  since_year      :integer
#  statuses        :jsonb            not null
#  until_month     :integer
#  until_year      :integer
#  address_id      :uuid
#  organization_id :uuid
#
# Indexes
#
#  index_organization_addresses_on_address_id       (address_id)
#  index_organization_addresses_on_organization_id  (organization_id)
#
