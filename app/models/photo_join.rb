class PhotoJoin < ApplicationRecord

  soft_deleteable

  belongs_to :photoable, polymorphic: true
  belongs_to :photo

end

# == Schema Information
#
# Table name: photo_joins
#
#  id             :uuid             not null, primary key
#  deleted        :boolean          default(FALSE)
#  photoable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  photo_id       :uuid
#  photoable_id   :uuid
#
# Indexes
#
#  index_photo_joins_on_photoable_id_and_photoable_type  (photoable_id,photoable_type)
#
