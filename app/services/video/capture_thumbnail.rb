class Video
  class CaptureThumbnail < ApplicationService

    attr_accessor :video, :seek_time

    def call
      cleanup_tmp_files

      thumbnail_path = Rails.root.join("tmp", "thumbnail-#{video.id}.png").to_s

      video_path = Rails.root.join("tmp", "video-#{video.id}.mp4").to_s
      open(video_path, "wb") { |file| file << video.file.read }

      movie = FFMPEG::Movie.new(video_path)

      seek_time = self.seek_time.presence || 3
      seek_time = 3 if seek_time > movie.duration
      seek_time = movie.duration if seek_time > movie.duration

      movie.screenshot(thumbnail_path, seek_time: seek_time)

      video.width  = movie.width
      video.height = movie.height

      File.open(thumbnail_path, "rb") do |file|
        video.thumbnail        = file
        video.thumbnail_width  = movie.width
        video.thumbnail_height = movie.height
      end

      video
    rescue
      nil
    ensure
      cleanup_tmp_files
    end

    private

    def cleanup_tmp_files
      FileUtils.rm_rf Dir[Rails.root.join("tmp", "thumbnail-*.png").to_s]
      FileUtils.rm_rf Dir[Rails.root.join("tmp", "video-*.mp4").to_s]
    end

  end
end
