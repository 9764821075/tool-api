class PersonActivitySerializer < ApplicationSerializer
  attributes :id, :role, :person_id, :activity_id

  belongs_to :person
  belongs_to :activity
end
