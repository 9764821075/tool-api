class PersonAddressSerializer < ApplicationSerializer
  attributes :id, :since, :until

  belongs_to :address
end
