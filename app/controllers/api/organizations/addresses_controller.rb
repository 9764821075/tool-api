class Api::Organizations::AddressesController < ApplicationController

  def index
    organization = find_organization
    organization_addresses = organization.organization_addresses.includes(:address, :sources)

    render json: organization_addresses
  end

  def create
    organization = find_organization

    organization_address = organization.organization_addresses.build(organization_address_params)
    organization_address.build_address(address_params)
    Source::Manage.(model: organization_address, urls: params[:sources])

    if organization_address.save
      render json: organization_address
    else
      head 422
    end
  end

  def update
    organization = find_organization

    organization_address = find_organization_address(organization)
    organization_address.assign_attributes(organization_address_params)
    organization_address.address.assign_attributes(address_params)
    Source::Manage.(model: organization_address, urls: params[:sources])

    if organization_address.save
      render json: organization_address
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    organization_address = find_organization_address(organization)
    organization_address.soft_delete

    head 200
  end

  private

  def organization_address_params
    params.permit(since: [:month, :year], until: [:month, :year])
  end

  def address_params
    pa = params.require(:address)
               .permit(:name, :line1, :zip_code, :city, country: [:code])
    pa[:country] ||= nil
    pa
  end

  def find_organization
    Organization.find(params[:organization_id])
  end

  def find_organization_address(organization)
    organization.organization_addresses.find(params[:id])
  end

end
