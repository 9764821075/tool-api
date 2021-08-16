class OrganizationAddressSerializer < ApplicationSerializer
  attributes :id, :since, :until

  belongs_to :address
  has_many :sources

end
