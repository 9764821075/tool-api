class Pdf < ApplicationRecord

  soft_deleteable has_many: [
    :source_joins,
    :pdf_joins
  ]

  belongs_to :pdfable, polymorphic: true, optional: true
  has_many :pdf_joins

  has_many :source_joins, as: :sourceable, autosave: true
  has_many :sources, through: :source_joins

  # needs to be here to execute before refile’s callbacks
  before_save :capture_thumbnail, if: :file_id_changed?
  before_save :set_color, if: :file_id_changed?

  attachment :thumbnail, type: :image
  attachment :file, type: :pdf

  validates :file, presence: true

  after_save { source_joins.reload }

  scope :order_by_date, -> { order("updated_at desc, id") }

  def presigned_url(expires_in = 1.day)
    return if file_id.blank?

    object = Aws::S3::Object.new(ENV.fetch("AWS_BUCKET"), "store/#{file_id}")
    object.presigned_url(:get, expires_in: expires_in)
  end

  private

  def capture_thumbnail
    Pdf::CaptureThumbnail.(pdf: self)
  end

  def set_color
    storage_path = Pathname.new(ENV.fetch('FILE_STORAGE_PATH')).join("store")
    file_path = storage_path.join(thumbnail_id)

    colors = Miro::DominantColors.new(file_path)
    hex_colors = colors.to_hex rescue []

    self.color = hex_colors.first || "#3f2d28"
  end

end

# == Schema Information
#
# Table name: pdfs
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
#  file_id                :string
#  thumbnail_id           :string
#
