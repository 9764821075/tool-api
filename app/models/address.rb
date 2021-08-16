class Address < ApplicationRecord
  include HasCountry

  auto_strip_attributes :name, :line1, :zip_code, :city, :region

  soft_deleteable has_many: [
    :organization_addresses,
    :person_addresses,
  ]

  has_many :organization_addresses, dependent: :destroy
  has_many :organizations, through: :organization_addresses

  has_many :person_addresses, dependent: :destroy
  has_many :people, through: :person_addresses

  validates :name, presence: true, length: { maximum: 250 }

  validates :line1,        length: { maximum: 250 }
  validates :zip_code,     length: { maximum: 250 }
  validates :city,         length: { maximum: 250 }
  validates :region,       length: { maximum: 250 }
  validates :country_code, inclusion: { in: I18nData.countries.keys }, allow_blank: true

end

# == Schema Information
#
# Table name: addresses
#
#  id           :uuid             not null, primary key
#  city         :string
#  country_code :string
#  deleted      :boolean          default(FALSE)
#  line1        :string
#  name         :string           not null
#  region       :string
#  zip_code     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_addresses_on_name  (name)
#
