class Profile < ApplicationRecord

  auto_strip_attributes :service, :username

  soft_deleteable

  belongs_to :person, optional: true
  belongs_to :organization, optional: true

  validates :service, presence: true, length: { maximum: 250 }
  validates :username, presence: true, length: { maximum: 250 }

end

# == Schema Information
#
# Table name: profiles
#
#  id              :uuid             not null, primary key
#  deleted         :boolean          default(FALSE)
#  service         :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid
#  person_id       :uuid
#
# Indexes
#
#  index_profiles_on_organization_id  (organization_id)
#  index_profiles_on_person_id        (person_id)
#
