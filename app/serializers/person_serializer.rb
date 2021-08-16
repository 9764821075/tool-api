class PersonSerializer < ApplicationSerializer
  attributes :id, :name, :nicknames, :phone, :email,
             :date_of_birth, :date_of_death, :birth_name, :place_of_birth

  attribute :resource do
    object.model_name.collection
  end

  attribute :nicknames do
    object.nicknames.pluck(:value)
  end

  attribute :profiles do
    object.profiles.pluck(:username)
  end

  attribute :organization_ids do
    object.organizations.pluck(:id).uniq
  end

  attribute :primary_photo_preview_src do
    primary_photo = object.primary_photo
    attachment_path(object.primary_photo, :file, :fill, 544, 680) if primary_photo
  end

  attribute :primary_photo_small_src do
    primary_photo = object.primary_photo
    attachment_path(object.primary_photo, :file, :fill, 40, 40) if primary_photo
  end
end
