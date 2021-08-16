class PhotoTag < ApplicationRecord

  soft_deleteable

  belongs_to :person
  belongs_to :photo

  validates :top,    numericality: { greater_than_or_equal_to: 0, less_than: 20_000 }
  validates :left,   numericality: { greater_than_or_equal_to: 0, less_than: 20_000 }
  validates :width,  numericality: { greater_than: 0, less_than: 20_000 }
  validates :height, numericality: { greater_than: 0, less_than: 20_000 }

end

# == Schema Information
#
# Table name: photo_tags
#
#  id         :uuid             not null, primary key
#  deleted    :boolean          default(FALSE)
#  height     :integer          not null
#  left       :integer          not null
#  top        :integer          not null
#  width      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :uuid             not null
#  photo_id   :uuid             not null
#
# Indexes
#
#  index_photo_tags_on_person_id  (person_id)
#  index_photo_tags_on_photo_id   (photo_id)
#
