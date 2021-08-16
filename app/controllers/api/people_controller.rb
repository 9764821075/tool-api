class Api::PeopleController < ApplicationController

  def index
    page = params[:page].presence
    query = params[:query].presence
    group = params[:group].presence

    records = Person.order_by_name.includes(:primary_photo)
    all_record_count = records.count

    records = records.search(query) if query
    records = records.joins(:organizations).where(organizations: { id: group }) if group
    filtered_record_count = records.count

    records = records.paginated(page.to_i) if page

    render json: {
      allRecordCount: all_record_count,
      filteredRecordCount: filtered_record_count,
      records: records.map { |record|
        PersonIndexSerializer.new(record).as_json
      },
    }
  end

  def list
    records = Person.order_by_name.includes(:primary_photo)
    render json: records, each_serializer: PersonResourceSerializer
  end

  def show
    render json: find_person
  end

  def primary_photo
    Refile.host = request.url

    person = find_person
    photo = person.primary_photo

    if photo
      render json: photo
    else
      head 404
    end
  end

  def set_primary_photo
    Refile.host = request.url

    person = find_person
    photo = find_photo(person)

    if person.update(primary_photo: photo)
      render json: photo
    else
      head 404
    end
  end

  def create
    person = Person.new(create_person_params)

    if person.save
      render json: person
    else
      render json: person.errors, status: 422
    end
  end

  def update
    person = find_person

    if person.update(update_person_params)
      render json: person
    else
      head 422
    end
  end

  def destroy
    person = find_person

    if person.soft_delete
      render json: person
    else
      head 422
    end
  end

  private

  def create_person_params
    params.permit(:name)
  end

  def update_person_params
    params.permit(:name, :date_of_birth, :date_of_death, :birth_name, :place_of_birth, :email, :phone)
  end

  def find_photo(person)
    person.photos.find(params[:photo_id])
  end

  def find_person
    Person.find(params[:person_id] || params[:id])
  end

end
