class Workplace < ApplicationRecord
  include SinceUntil
  include HasCountry

  auto_strip_attributes :name, :position, :line1, :zip_code, :city, :region

  soft_deleteable

  belongs_to :person

  validates :name, presence: true, length: { maximum: 250 }

  validates :position, length: { maximum: 250 }
  validates :line1,    length: { maximum: 250 }
  validates :zip_code, length: { maximum: 250 }
  validates :city,     length: { maximum: 250 }
  validates :region,   length: { maximum: 250 }
  validates :country_code, inclusion: { in: I18nData.countries.keys }, allow_blank: true

end

# == Schema Information
#
# Table name: workplaces
#
#  id           :uuid             not null, primary key
#  city         :string
#  country_code :string
#  deleted      :boolean          default(FALSE)
#  line1        :string
#  name         :string           not null
#  position     :string
#  region       :string
#  since_month  :integer
#  since_year   :integer
#  until_month  :integer
#  until_year   :integer
#  zip_code     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :uuid             not null
#
# Indexes
#
#  index_workplaces_on_name       (name)
#  index_workplaces_on_person_id  (person_id)
#
