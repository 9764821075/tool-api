class Organization < ApplicationRecord
  include PgSearch::Model
  include Pagination

  auto_strip_attributes :name

  pg_search_scope :search,
                  against: [:name, :shortname],
                  ignoring: :accents,
                  using: {
                    tsearch: {
                      prefix: true
                    },
                  }

  soft_deleteable has_one: [
    :logo
  ], has_many: [
    :organization_associations,
    :organization_addresses,
    :organization_activities,
    :profiles,
    :photos,
    :note_joins,
    :screenshot_joins,
    :pdf_joins,
  ]

  has_ancestry

  has_many :organization_associations, dependent: :destroy
  has_many :people, through: :organization_associations

  has_many :organization_addresses, dependent: :destroy
  has_many :addresses, through: :organization_addresses

  has_many :organization_activities, dependent: :destroy
  has_many :activities, through: :organization_activities

  has_many :photo_joins, as: :photoable
  has_many :photos, through: :photo_joins

  has_many :screenshot_joins, as: :screenshotable
  has_many :screenshots, through: :screenshot_joins

  has_many :pdf_joins, as: :pdfable
  has_many :pdfs, through: :pdf_joins

  has_many :note_joins, as: :noteable, autosave: true
  has_many :notes, through: :note_joins

  has_many :profiles, dependent: :destroy

  has_one :logo, dependent: :destroy, required: false

  validates :name, presence: true, length: { maximum: 250 }, uniqueness: { conditions: -> { existing } }
  validates :shortname, length: { maximum: 50 }

  before_save :set_names_depth_cache
  after_commit :update_names_depth_cache_of_children

  accepts_nested_attributes_for :logo

  scope :order_by_name, -> { order("lower(name), id") }
  scope :order_by_ancestry, -> { order("names_depth_cache, id") }

  def count_all_people
    descendants.sum { |descendant| descendant.people.count } + people.count
  end

  def count_all_activities
    descendants.sum { |descendant| descendant.activities.count } + activities.count
  end

  def set_names_depth_cache
    path_names = ancestors.map(&:name)
    path_names << self.name

    self.names_depth_cache = path_names.join('/').downcase
  end

  def update_names_depth_cache_of_children
    children.each do |child|
      child.set_names_depth_cache
      child.save
    end
  end

end

# == Schema Information
#
# Table name: organizations
#
#  id                :uuid             not null, primary key
#  ancestry          :string
#  deleted           :boolean          default(FALSE)
#  name              :string           not null
#  names_depth_cache :string
#  shortname         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_organizations_on_ancestry  (ancestry)
#  index_organizations_on_name      (name) UNIQUE
#
