class PersonActivity < ApplicationRecord

  auto_strip_attributes :role

  soft_deleteable

  belongs_to :activity
  belongs_to :person

  delegate :sort_date, to: :activity

  validates :activity_id, presence: true
  validates :person_id,   presence: true

  validates :role, length: { maximum: 250 }

end

# == Schema Information
#
# Table name: person_activities
#
#  id          :uuid             not null, primary key
#  deleted     :boolean          default(FALSE)
#  role        :string
#  activity_id :uuid
#  person_id   :uuid
#
# Indexes
#
#  index_person_activities_on_activity_id  (activity_id)
#  index_person_activities_on_person_id    (person_id)
#
