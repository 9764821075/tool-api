class Api::People::OrganizationsController < ApplicationController

  def index
    person = find_person
    organization_associations = person.organization_associations.includes(organization: [:logo])

    render json: organization_associations
  end

  def create
    person = find_person
    organization_association = person.organization_associations.build(organization_association_params)

    if organization_association.save
      render json: organization_association
    else
      head 422
    end
  end

  def update
    person = find_person
    organization_association = find_organization_association(person)
    organization_association.assign_attributes(organization_association_params)

    if organization_association.save
      render json: organization_association
    else
      head 422
    end
  end

  def destroy
    person = find_person

    organization_association = find_organization_association(person)
    organization_association.soft_delete

    head 200
  end

  private

  def organization_association_params
    params.permit(:position, organization: [:id], since: [:month, :year], until: [:month, :year])
          .tap { |p| p[:organization_id] = p[:organization][:id]; p.delete(:organization) }
  end

  def find_person
    Person.includes(:organizations).find(params[:person_id])
  end

  def find_organization_association(person)
    person.organization_associations.find(params[:id])
  end

end
