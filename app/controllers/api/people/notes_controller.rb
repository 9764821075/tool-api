class Api::People::NotesController < ApplicationController

  def index
    person = find_person
    notes = person.notes.includes(:sources)

    render json: notes
  end

  def create
    person = find_person
    note = person.notes.build(note_params)
    Source::Manage.(model: note, urls: params[:sources])

    if person.save
      render json: note
    else
      head 422
    end
  end

  def update
    person = find_person
    note = find_note(person)

    note.assign_attributes(note_params)
    Source::Manage.(model: note, urls: params[:sources])

    if note.save
      render json: note
    else
      head 422
    end
  end

  def destroy
    person = find_person

    note = find_note(person)
    note.soft_delete

    head 200
  end

  private

  def note_params
    params.permit(:title, :date, :text)
  end

  def find_person
    Person.find(params[:person_id])
  end

  def find_note(person)
    person.notes.find(params[:id])
  end

end
