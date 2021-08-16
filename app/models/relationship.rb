class Relationship < ApplicationRecord

  soft_deleteable has_many: [
    :source_joins,
  ]

  enum status: { in_contact: 0, friendship: 1, relationship: 2, engaged: 3, marriage: 4, related: 5, former_relationship: 6 }

  belongs_to :person
  belongs_to :friend, class_name: "Person"

  has_many :source_joins, as: :sourceable, autosave: true
  has_many :sources, through: :source_joins

  validates_presence_of :friend_id
  validates_presence_of :status

end

# == Schema Information
#
# Table name: relationships
#
#  id         :uuid             not null, primary key
#  deleted    :boolean          default(FALSE)
#  info       :text
#  status     :integer          default("in_contact")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :uuid
#  person_id  :uuid
#
# Indexes
#
#  index_relationships_on_friend_id  (friend_id)
#  index_relationships_on_person_id  (person_id)
#
