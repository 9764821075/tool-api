class Api::Organizations::MembersController < ApplicationController

  def index
    organization = find_organization
    organization_associations = organization.organization_associations.includes(person: [:primary_photo, :organizations])

    render json: organization_associations
  end

  def create
    organization = find_organization
    organization_association = organization.organization_associations.build(organization_association_params)

    if organization_association.save
      render json: organization_association
    else
      head 422
    end
  end

  def update
    organization = find_organization
    organization_association = find_organization_association(organization)
    organization_association.assign_attributes(organization_association_params)

    if organization_association.save
      render json: organization_association
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    organization_association = find_organization_association(organization)
    organization_association.soft_delete

    head 200
  end

  private

  def organization_association_params
    params.permit(:position, person: [:id], since: [:month, :year], until: [:month, :year])
          .tap { |p| p[:person_id] = p[:person][:id]; p.delete(:person) }
  end

  def find_organization
    Organization.find(params[:organization_id])
  end

  def find_organization_association(organization)
    organization.organization_associations.find(params[:id])
  end

end
