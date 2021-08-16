class Api::People::AddressesController < ApplicationController

  def index
    person = find_person
    person_addresses = person.person_addresses.includes(:address)

    render json: person_addresses
  end

  def create
    person = find_person

    person_address = person.person_addresses.build(person_address_params)
    person_address.build_address(address_params)

    if person_address.save
      render json: person_address
    else
      head 422
    end
  end

  def update
    person = find_person

    person_address = find_person_address(person)
    person_address.assign_attributes(person_address_params)
    person_address.address.assign_attributes(address_params)

    if person_address.save
      render json: person_address
    else
      head 422
    end
  end

  def destroy
    person = find_person

    person_address = find_person_address(person)
    person_address.soft_delete

    head 200
  end

  private

  def person_address_params
    params.permit(since: [:month, :year], until: [:month, :year])
  end

  def address_params
    pa = params.require(:address)
               .permit(:name, :line1, :zip_code, :city, country: [:code])
    pa[:country] ||= nil
    pa
  end

  def find_person
    Person.find(params[:person_id])
  end

  def find_person_address(person)
    person.person_addresses.find(params[:id])
  end

end
