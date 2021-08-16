class Api::People::ProfilesController < ApplicationController

  def index
    person = find_person
    profiles = person.profiles

    render json: profiles
  end

  def create
    person = find_person
    profile = person.profiles.build(profile_params)

    if profile.save
      render json: profile
    else
      head 422
    end
  end

  def update
    person = find_person
    profile = find_profile(person)
    profile.assign_attributes(profile_params)

    if profile.save
      render json: profile
    else
      head 422
    end
  end

  def destroy
    person = find_person

    profile = find_profile(person)
    profile.soft_delete

    head 200
  end

  private

  def profile_params
    params.permit(:service, :username)
  end

  def find_person
    Person.find(params[:person_id])
  end

  def find_profile(person)
    person.profiles.find(params[:id])
  end

end
