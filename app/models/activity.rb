class Activity < ApplicationRecord
  include PgSearch::Model
  include Pagination
  include HasCountry

  auto_strip_attributes :name, :location, :city, :number_of_people, :zip_code

  pg_search_scope :search,
                  against: :name,
                  ignoring: :accents,
                  using: {
                    tsearch: {
                      prefix: true
                    },
                  }

  soft_deleteable has_many: [
    :organization_activities,
    :person_activities,
    :photos,
    :videos,
    :note_joins,
    :screenshot_joins,
  ]

  has_many :organization_activities, dependent: :destroy
  has_many :organizations, through: :organization_activities

  has_many :person_activities, dependent: :destroy
  has_many :people, through: :person_activities

  has_many :videos, dependent: :destroy

  has_many :photo_joins, as: :photoable #, autosave: true
  has_many :photos, through: :photo_joins
  has_many :photo_tags, through: :photos, source: :tags

  belongs_to :primary_photo, optional: true, class_name: "Photo"

  has_many :note_joins, as: :noteable, autosave: true
  has_many :notes, through: :note_joins

  has_many :screenshot_joins, as: :screenshotable
  has_many :screenshots, through: :screenshot_joins

  accepts_attachments_for :photos, attachment: :file, append: true

  validates :name, presence: true, length: { maximum: 250 }

  validates :location,     length: { maximum: 250 }
  validates :zip_code,     length: { maximum: 250 }
  validates :city,         length: { maximum: 250 }
  validates :region,       length: { maximum: 250 }, allow_blank: true
  validates :country_code, inclusion: { in: I18nData.countries.keys }, allow_blank: true

  validates :number_of_people, length: { maximum: 250 }

  validates :date_day,   day:   true, allow_blank: true
  validates :date_month, month: true, allow_blank: true
  validates :date_year,  year:  true, allow_blank: true

  scope :order_by_date, -> { order("date_year DESC, date_month DESC, date_day DESC, id") }
  scope :order_by_name, -> { order("name, id") }

  def all_people
    tagged_people  = photo_tags.includes(:person, photo: [:person]).map { |tag| tag.try(:person) }
    all_activities = person_activities.includes(:person) + tagged_people

    all_activities.compact
                  .uniq { |record| record.try(:person).try(:id) || record.id }
                  .sort_by { |record| record.try(:name) || record.try(:person).try(:name) || "" }
  end

  def attendance=(value)
    self.number_of_people = value
  end

  def attendance
    self.number_of_people
  end

  def date
    {
      day: date_day.presence,
      month: date_month.presence,
      year: date_year.presence,
    }
  end

  def date=(value)
    self.date_day = value.fetch(:day).presence
    self.date_month = value.fetch(:month).presence
    self.date_year = value.fetch(:year).presence
  end

  def sort_date
    Date.new(
      date_year  || 1900,
      date_month || 1,
      date_day   || 1
    )
  end

end

# == Schema Information
#
# Table name: activities
#
#  id               :uuid             not null, primary key
#  city             :string
#  country_code     :string
#  date_day         :integer
#  date_month       :integer
#  date_year        :integer
#  deleted          :boolean          default(FALSE)
#  location         :string
#  name             :string           not null
#  notes            :text
#  number_of_people :string
#  region           :string
#  zip_code         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  primary_photo_id :uuid
#
# Indexes
#
#  index_activities_on_name              (name)
#  index_activities_on_primary_photo_id  (primary_photo_id)
#
