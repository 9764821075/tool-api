class Api::People::RelationshipsController < ApplicationController

  def index
    person = find_person
    relationships = person.relationships.includes(:friend)

    render json: relationships
  end

  def create
    person = find_person
    relationship = person.create_relationship(relationship_params)
    Source::Manage.(model: relationship, urls: params[:sources])

    if relationship.save
      render json: relationship
    else
      render json: relationship.errors, status: 422
    end
  end

  def update
    person = find_person
    relationship = find_relationship(person)

    relationship.assign_attributes(relationship_params)
    Source::Manage.(model: relationship, urls: params[:sources])

    if relationship.save
      render json: relationship
    else
      render json: relationship.errors, status: 422
    end
  end

  def destroy
    person = find_person

    relationship = find_relationship(person)
    relationship.soft_delete

    head 200
  end

  private

  def relationship_params
    params.permit(:info, status: [:key], person: [:id], friend: [:id])
          .tap { |p| p[:status] && p[:status] = p[:status][:key] }
          .tap { |p| p[:person] && p[:person_id] = p[:person][:id]; p.delete(:person) }
          .tap { |p| p[:friend] && p[:friend_id] = p[:friend][:id]; p.delete(:friend) }
          .tap { |pa| puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"; p pa }
  end

  def find_person
    Person.find(params[:person_id])
  end

  def find_relationship(person)
    person.relationships.find(params[:id])
  end

end
