class PhotoTagSerializer < ApplicationSerializer
  attributes :id, :person_id, :photo_id, :rect

  attribute :person_name do
    object.person.name
  end

  belongs_to :person, serializer: PersonResourceSerializer

  attribute :organizations do
    object.person.organizations
      .select(:id, :name)
      .pluck(:id, :name)
      .uniq
      .map { |id, name| { id: id, name: name, resource: "organizations" } }
  end

  def rect
    {
      top:    object.top,
      left:   object.left,
      width:  object.width,
      height: object.height
    }
  end
end
