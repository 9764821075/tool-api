class Api::Activities::ParticipantsController < ApplicationController

  def index
    activity = find_activity
    person_activities = activity.person_activities.includes(person: [:primary_photo, :organizations])

    render json: person_activities
  end

  def create
    activity = find_activity
    person_activity = activity.person_activities.build(person_activity_params)

    if person_activity.save
      render json: person_activity
    else
      head 422
    end
  end

  def update
    activity = find_activity
    person_activity = find_person_activity(activity)
    person_activity.assign_attributes(person_activity_params)

    if person_activity.save
      render json: person_activity
    else
      head 422
    end
  end

  def destroy
    activity = find_activity

    person_activity = find_person_activity(activity)
    person_activity.soft_delete

    head 200
  end

  private

  def person_activity_params
    params.permit(:role, person: [:id])
          .tap { |p| p[:person_id] = p[:person][:id]; p.delete(:person) }
  end

  def find_activity
    Activity.find(params[:activity_id])
  end

  def find_person_activity(activity)
    activity.person_activities.find(params[:id])
  end
end
