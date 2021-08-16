class RelationshipSerializer < ApplicationSerializer
  attributes :id, :status, :info

  belongs_to :friend, serializer: PersonResourceSerializer
  belongs_to :person, serializer: PersonResourceSerializer

end
