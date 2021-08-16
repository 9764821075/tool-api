class Api::Organizations::ProfilesController < ApplicationController

  def index
    organization = find_organization
    profiles = organization.profiles

    render json: profiles
  end

  def create
    organization = find_organization
    profile = organization.profiles.build(profile_params)

    if profile.save
      render json: profile
    else
      head 422
    end
  end

  def update
    organization = find_organization
    profile = find_profile(organization)
    profile.assign_attributes(profile_params)

    if profile.save
      render json: profile
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    profile = find_profile(organization)
    profile.soft_delete

    head 200
  end

  private

  def profile_params
    params.permit(:service, :username)
  end

  def find_organization
    Organization.find(params[:organization_id])
  end

  def find_profile(organization)
    organization.profiles.find(params[:id])
  end

end
