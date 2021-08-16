class Api::Activities::VideosController < ApplicationController

  def index
    activity = find_activity
    videos = activity.videos.order_by_date.includes(:sources)

    render json: paginate(videos)
  end

  def upload_spec
    activity = find_activity
    upload_spec = UploadSpec.(record: activity.videos.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    activity = find_activity
    video = activity.videos.build(video_params)
    Source::Manage.(model: video, urls: params[:sources])

    if video.save
      render json: VideoSerializer.new(video).to_hash
    else
      head 422
    end
  end

  def update
    activity = find_activity
    video = find_video(activity)

    video.assign_attributes(video_params)
    Source::Manage.(model: video, urls: params[:sources])

    if video.save
      render json: VideoSerializer.new(video).to_hash
    else
      head 422
    end
  end

  def destroy
    activity = find_activity

    video = find_video(activity)
    video.soft_delete

    head 200
  end

  private

  def video_params
    params = self.params.permit(:file, :seek_time, :description)

    # Workaround for https://github.com/refile/refile/pull/462
    params.delete(:file) if params[:file] == "{}"
    params
  end

  def find_activity
    Activity.find(params[:activity_id])
  end

  def find_video(activity)
    activity.videos.find(params[:id])
  end

end
