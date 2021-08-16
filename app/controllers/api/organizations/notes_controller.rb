class Api::Organizations::NotesController < ApplicationController

  def index
    organization = find_organization
    notes = organization.notes

    render json: notes
  end

  def create
    organization = find_organization
    note = organization.notes.build(note_params)
    Source::Manage.(model: note, urls: params[:sources])

    if organization.save
      render json: note
    else
      head 422
    end
  end

  def update
    organization = find_organization
    note = find_note(organization)

    note.assign_attributes(note_params)
    Source::Manage.(model: note, urls: params[:sources])

    if note.save
      render json: note
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    note = find_note(organization)
    note.soft_delete

    head 200
  end

  private

  def note_params
    params.permit(:title, :date, :text)
  end

  def find_organization
    Organization.find(params[:organization_id])
  end

  def find_note(organization)
    organization.notes.find(params[:id])
  end

end
