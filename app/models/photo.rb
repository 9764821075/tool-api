class Photo < ApplicationRecord

  soft_deleteable has_many: [
    :tags,
    :source_joins
  ]

  has_many :tags, class_name: "PhotoTag"

  belongs_to :photoable, polymorphic: true, optional: true
  has_many :photo_joins

  has_many :source_joins, as: :sourceable, autosave: true
  has_many :sources, through: :source_joins

  belongs_to :person,   optional: true
  belongs_to :activity, optional: true

  attachment :file, type: :image

  validates :file, presence: true

  after_save { source_joins.reload }
  before_save :set_dimensions_and_color, if: :file_id_changed?

  scope :order_by_date, -> { order("updated_at desc, id") }

  def activities
    photo_joins.where(photoable_type: "Activity").map(&:photoable)
  end

  def presigned_url(expires_in = 1.day)
    return if file_id.blank?

    object = Aws::S3::Object.new(ENV.fetch("AWS_BUCKET"), "store/#{file_id}")
    object.presigned_url(:get, expires_in: expires_in)
  end

  private

  def set_dimensions_and_color
    storage_path = Rails.root.join("storage").join("store")
    file_path = storage_path.join(file_id)

    image = MiniMagick::Image.open(file_path)

    self.width  = image.width
    self.height = image.height

    colors = Miro::DominantColors.new(file_path)
    hex_colors = colors.to_hex rescue []

    self.color = hex_colors.first || "#3f2d28"
  end

end

# == Schema Information
#
# Table name: photos
#
#  id                :uuid             not null, primary key
#  color             :string
#  deleted           :boolean          default(FALSE)
#  description       :text
#  file_content_type :string
#  file_filename     :string
#  file_size         :integer
#  height            :integer
#  width             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  activity_id       :uuid
#  file_id           :string
#  person_id         :uuid
#
# Indexes
#
#  index_photos_on_activity_id  (activity_id)
#  index_photos_on_person_id    (person_id)
#
