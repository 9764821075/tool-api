class Api::People::ActivitiesController < ApplicationController

  def index
    person = find_person
    activities = person.all_activities

    render json: activities
  end

  def create
    person = find_person
    person_activity = person.person_activities.build(person_activity_params)

    if person_activity.save
      render json: person_activity
    else
      head 422
    end
  end

  def update
    person = find_person
    person_activity = find_person_activity(person)
    person_activity.assign_attributes(person_activity_params)

    if person_activity.save
      render json: person_activity
    else
      head 422
    end
  end

  def destroy
    person = find_person

    person_activity = find_person_activity(person)
    person_activity.soft_delete

    head 200
  end

  private

  def person_activity_params
    params.permit(:role, activity: [:id])
          .tap { |p| p[:activity_id] = p[:activity][:id]; p.delete(:activity) }
  end

  def find_person
    Person.find(params[:person_id])
  end

  def find_person_activity(person)
    person.person_activities.find(params[:id])
  end

end
