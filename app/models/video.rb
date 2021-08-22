class Video < ApplicationRecord

  soft_deleteable has_many: [
    :source_joins,
  ]

  belongs_to :person,   optional: true
  belongs_to :activity, optional: true

  has_many :source_joins, as: :sourceable, autosave: true
  has_many :sources, through: :source_joins

  # needs to be here to execute before refile’s callbacks
  before_save :capture_thumbnail, if: :file_id_changed?
  before_save :set_color, if: :file_id_changed?

  attribute :seek_time, :integer

  attachment :thumbnail, type: :image
  attachment :file, type: :video

  validates :file, presence: true
  validates :seek_time, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 1000 }, allow_blank: true

  scope :order_by_date, -> { order("updated_at desc, id") }

  private

  def capture_thumbnail
    Video::CaptureThumbnail.(video: self, seek_time: seek_time)
  end

  def set_color
    storage_path = Rails.root.join("storage").join("store")
    file_path = storage_path.join(thumbnail_id)

    colors = Miro::DominantColors.new(file_path)
    hex_colors = colors.to_hex rescue []

    self.color = hex_colors.first || "#3f2d28"
  end

end

# == Schema Information
#
# Table name: videos
#
#  id                     :uuid             not null, primary key
#  color                  :string
#  deleted                :boolean          default(FALSE)
#  description            :text
#  file_content_type      :string
#  file_filename          :string
#  file_size              :integer
#  height                 :integer
#  thumbnail_content_type :string
#  thumbnail_filename     :string
#  thumbnail_height       :integer
#  thumbnail_size         :integer
#  thumbnail_width        :integer
#  width                  :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  activity_id            :uuid
#  file_id                :string
#  person_id              :uuid
#  thumbnail_id           :string
#
# Indexes
#
#  index_videos_on_activity_id  (activity_id)
#  index_videos_on_person_id    (person_id)
#
