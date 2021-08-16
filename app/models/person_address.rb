class PersonAddress < ApplicationRecord
  include SinceUntil

  soft_deleteable

  belongs_to :person
  belongs_to :address, autosave: true

  validates_associated :address

end

# == Schema Information
#
# Table name: person_addresses
#
#  id          :uuid             not null, primary key
#  deleted     :boolean          default(FALSE)
#  since_month :integer
#  since_year  :integer
#  until_month :integer
#  until_year  :integer
#  address_id  :uuid
#  person_id   :uuid
#
# Indexes
#
#  index_person_addresses_on_address_id  (address_id)
#  index_person_addresses_on_person_id   (person_id)
#
