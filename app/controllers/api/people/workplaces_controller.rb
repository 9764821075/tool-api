class Api::People::WorkplacesController < ApplicationController

  def index
    person = find_person
    workplaces = person.workplaces

    render json: workplaces
  end

  def create
    person = find_person
    workplace = person.workplaces.build(workplace_params)

    if workplace.save
      render json: workplace
    else
      head 422
    end
  end

  def update
    person = find_person
    workplace = find_workplace(person)

    if workplace.update(workplace_params)
      render json: workplace
    else
      head 422
    end
  end

  def destroy
    person = find_person

    workplace = find_workplace(person)
    workplace.soft_delete

    head 200
  end

  private

  def workplace_params
    pa = params.permit(:name, :position, :line1, :zip_code, :city,
                       country: [:code],
                       since: [:month, :year],
                       until: [:month, :year])
    pa[:country] ||= nil
    pa
  end

  def find_person
    Person.find(params[:person_id])
  end

  def find_workplace(person)
    person.workplaces.find(params[:id])
  end

end
