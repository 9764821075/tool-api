class ExportResult < ApplicationRecord

  attachment :file #, type: :zip

  validates :file, presence: true

  def presigned_url(expires_in = 10.minutes)
    return if file_id.blank?

    filename = file_filename.presence || "export.zip"

    object = Aws::S3::Object.new(ENV.fetch("AWS_BUCKET"), "store/#{file_id}")
    object.presigned_url(:get, expires_in: expires_in, response_content_disposition: "attachment;filename=#{filename}")
  end

end

# == Schema Information
#
# Table name: export_results
#
#  id                :uuid             not null, primary key
#  duration          :integer
#  file_content_type :string
#  file_count        :integer
#  file_filename     :string
#  file_size         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_id           :string
#
