class Api::ActivitiesController < ApplicationController

  def index
    page = params[:page].presence
    query = params[:query].presence
    group = params[:group].presence

    records = Activity.order_by_date.includes(:primary_photo)
    all_record_count = records.count

    records = records.search(query) if query
    records = records.joins(:organizations).where(organizations: { id: group }) if group
    filtered_record_count = records.count

    records = records.paginated(page.to_i) if page

    render json: {
      allRecordCount: all_record_count,
      filteredRecordCount: filtered_record_count,
      records: records.map { |record|
        ActivityIndexSerializer.new(record).as_json
      },
    }
  end

  def list
    records = Activity.order_by_name.includes(:primary_photo)
    render json: records, each_serializer: ActivityResourceSerializer
  end

  def show
    render json: find_activity
  end

  def photos_of_person
    activity = Activity.find(params[:activity_id])
    photos = activity.photo_tags.where(person_id: params[:person_id]).map(&:photo)

    render json: photos
  end

  def primary_photo
    Refile.host = request.url

    activity = find_activity
    photo = activity.primary_photo

    if photo
      render json: photo
    else
      head 404
    end
  end

  def set_primary_photo
    Refile.host = request.url

    activity = find_activity
    photo = find_photo(activity)

    if activity.update(primary_photo: photo)
      render json: photo
    else
      head 404
    end
  end

  def create
    activity = Activity.new(create_activity_params)

    if activity.save
      render json: activity
    else
      render json: activity.errors, status: 422
    end
  end

  def update
    activity = find_activity

    if activity.update(update_activity_params)
      render json: activity
    else
      head 422
    end
  end

  def destroy
    activity = find_activity

    if activity.soft_delete
      render json: activity
    else
      head 422
    end
  end

  private

  def create_activity_params
    params.permit(:name)
  end

  def update_activity_params
    params.permit(:name, :attendance, :location, :zip_code, :city, country: [:code],
                  date: [:day, :month, :year])
  end

  def find_photo(activity)
    activity.photos.find(params[:photo_id])
  end

  def find_activity
    Activity.find(params[:activity_id] || params[:id])
  end

end
