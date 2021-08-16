class Api::Activities::OrganizationsController < ApplicationController

  def index
    activity = find_activity
    organization_activities = activity.organization_activities.includes(:organization)

    render json: organization_activities
  end

  def create
    activity = find_activity
    organization_activity = activity.organization_activities.build(organization_activity_params)

    if organization_activity.save
      render json: organization_activity
    else
      head 422
    end
  end

  def update
    activity = find_activity
    organization_activity = organization_activity(activity)
    organization_activity.assign_attributes(organization_activity_params)

    if organization_activity.save
      render json: organization_activity
    else
      head 422
    end
  end

  def destroy
    activity = find_activity

    organization_activity = organization_activity(activity)
    organization_activity.soft_delete

    head 200
  end

  private

  def organization_activity_params
    params.permit(:role, organization: [:id])
          .tap { |p| p[:organization_id] = p[:organization][:id]; p.delete(:organization) }
  end

  def find_activity
    Activity.find(params[:activity_id])
  end

  def organization_activity(activity)
    activity.organization_activities.find(params[:id])
  end
end
