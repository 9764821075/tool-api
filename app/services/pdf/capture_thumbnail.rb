class Pdf
  class CaptureThumbnail < ApplicationService

    attr_accessor :pdf

    def call
      cleanup_tmp_files

      thumbnail_path = Rails.root.join("tmp", "thumbnail-#{pdf.id || 'new'}.png").to_s

      pdf_path = Rails.root.join("tmp", "pdf-#{pdf.id || 'new'}.pdf").to_s
      open(pdf_path, "wb") { |file| file << pdf.file.read }

      doc = MiniMagick::Image.new(pdf_path)
      doc.pages.first.write(thumbnail_path)

      File.open(thumbnail_path, "rb") do |file|
        pdf.thumbnail        = file
        pdf.thumbnail_width  = doc.width
        pdf.thumbnail_height = doc.height
      end

      pdf
    rescue
      nil
    ensure
      cleanup_tmp_files
    end

    private

    def cleanup_tmp_files
      FileUtils.rm_rf Dir[Rails.root.join("tmp", "thumbnail-*.png").to_s]
      FileUtils.rm_rf Dir[Rails.root.join("tmp", "pdf-*.pdf").to_s]
    end

  end
end
