class SourceAuthor < ApplicationRecord

  soft_deleteable

  validates :service,  presence: true, length: { maximum: 250 }
  validates :username, presence: true, length: { maximum: 250 }
  validates :author,   presence: true, length: { maximum: 250 }

end

# == Schema Information
#
# Table name: source_authors
#
#  id         :uuid             not null, primary key
#  author     :string           not null
#  deleted    :boolean          default(FALSE)
#  service    :string           not null
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_source_authors_on_service_and_username  (service,username) UNIQUE WHERE ((deleted = false) OR (deleted IS NULL))
#
