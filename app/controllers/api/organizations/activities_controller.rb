class Api::Organizations::ActivitiesController < ApplicationController

  def index
    organization = find_organization
    organization_activities = organization.organization_activities.includes(activity: [:primary_photo, :organizations])

    render json: organization_activities
  end

  def create
    organization = find_organization
    organization_activity = organization.organization_activities.build(organization_activity_params)

    if organization_activity.save
      render json: organization_activity
    else
      head 422
    end
  end

  def update
    organization = find_organization
    organization_activity = find_organization_activity(organization)
    organization_activity.assign_attributes(organization_activity_params)

    if organization_activity.save
      render json: organization_activity
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    organization_activity = find_organization_activity(organization)
    organization_activity.soft_delete

    head 200
  end

  private

  def organization_activity_params
    params.permit(:role, activity: [:id])
          .tap { |p| p[:activity_id] = p[:activity][:id]; p.delete(:activity) }
  end

  def find_organization
    Organization.find(params[:organization_id])
  end

  def find_organization_activity(organization)
    organization.organization_activities.find(params[:id])
  end

end
