class Logo < ApplicationRecord

  soft_deleteable

  belongs_to :organization

  attachment :file, type: :image

  validates :file, presence: true

  before_save :set_dimensions_and_color, if: :file_id_changed?

  private

  def set_dimensions_and_color
    tmp = file.download
    image = MiniMagick::Image.open(tmp.path)

    self.width  = image.width
    self.height = image.height

    colors = Miro::DominantColors.new(tmp.path)
    hex_colors = colors.to_hex rescue []

    self.color = hex_colors.first || "#3f2d28"
  end

end

# == Schema Information
#
# Table name: logos
#
#  id                :uuid             not null, primary key
#  color             :string
#  deleted           :boolean          default(FALSE)
#  file_content_type :string
#  file_filename     :string
#  file_size         :integer
#  height            :integer
#  width             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_id           :string
#  organization_id   :uuid
#
