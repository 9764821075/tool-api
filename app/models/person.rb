class Person < ApplicationRecord
  include PgSearch::Model
  include Pagination

  pg_search_scope :search,
                  against: [:name, :birth_name, :email, :phone, :nicknames],
                  ignoring: :accents,
                  using: {
                    tsearch: {
                      prefix: true
                    },
                  }

  auto_strip_attributes :name, :phone, :email, :birth_name, :place_of_birth

  soft_deleteable has_many: [
    :relationships,
    :organization_associations,
    :person_addresses,
    :person_activities,
    :workplaces,
    :profiles,
    :photos,
    :videos,
    :note_joins,
    :screenshot_joins,
  ]

  has_many :relationships_as_person, foreign_key: :person_id, class_name: "Relationship", dependent: :destroy
  has_many :relationships_as_friend, foreign_key: :friend_id, class_name: "Relationship", dependent: :destroy

  has_many :organization_associations, dependent: :destroy
  has_many :organizations, through: :organization_associations

  has_many :person_addresses, dependent: :destroy
  has_many :addresses, through: :person_addresses

  has_many :person_activities, dependent: :destroy
  has_many :activities, through: :person_activities

  has_many :screenshot_joins, as: :screenshotable
  has_many :screenshots, through: :screenshot_joins

  has_many :photo_joins, as: :photoable
  has_many :photos, through: :photo_joins

  belongs_to :primary_photo, optional: true, class_name: "Photo"

  has_many :photo_tags, dependent: :destroy
  has_many :workplaces, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_many :videos, dependent: :destroy

  has_many :note_joins, as: :noteable, autosave: true
  has_many :notes, through: :note_joins

  validates :name, presence: true, length: { maximum: 250 }

  validates :birth_name, length: { maximum: 250 }, allow_blank: true
  validates :place_of_birth, length: { maximum: 250 }, allow_blank: true

  validates :phone, length: { maximum: 250 }
  validates :email, length: { maximum: 250 }

  scope :order_by_name, -> { order("lower(people.name), people.id") }

  def full_name
    name = self.name
    name += " (geb. #{birth_name})" if birth_name.present?
    name
  end

  def add_nickname(nickname)
    return if nickname.blank?
    read_attribute(:nicknames).append(nickname)
  end

  def update_nickname(position, nickname)
    return if nickname.blank?
    read_attribute(:nicknames)[position] = nickname
  end

  def remove_nickname(position)
    read_attribute(:nicknames).delete_at(position)
  end

  def nicknames
    read_attribute(:nicknames).map.with_index { |nickname, index|
      Nickname.new(id: index, value: nickname)
    }
  end

  def age
    now = Time.now.utc.to_date
    now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end

  def create_relationship(params)
    relationships_as_person.build(params)
  end

  def relationships
    Relationship.where(
      id: relationships_as_person.pluck(:id) +
          relationships_as_friend.pluck(:id)
    )
  end

  def all_activities
    tagged_activities = photo_tags.includes(:photo).map(&:photo).reject(&:blank?).flat_map(&:activities)
    all_activities    = person_activities.includes(activity: [:primary_photo, :organizations]) + tagged_activities

    all_activities.compact.uniq(&:id).sort_by(&:sort_date).reverse!
  end

end

# == Schema Information
#
# Table name: people
#
#  id               :uuid             not null, primary key
#  birth_name       :string
#  date_of_birth    :date
#  date_of_death    :date
#  deleted          :boolean          default(FALSE)
#  email            :string
#  name             :string           not null
#  nicknames        :string           default([]), is an Array
#  noname           :boolean          default(FALSE)
#  notes            :text
#  phone            :string
#  place_of_birth   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  primary_photo_id :uuid
#
# Indexes
#
#  index_people_on_primary_photo_id  (primary_photo_id)
#
