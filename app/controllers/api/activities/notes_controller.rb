class Api::Activities::NotesController < ApplicationController

  def index
    activity = find_activity
    notes = activity.notes

    render json: notes
  end

  def create
    activity = find_activity
    note = activity.notes.build(note_params)
    Source::Manage.(model: note, urls: params[:sources])

    if activity.save
      render json: note
    else
      head 422
    end
  end

  def update
    activity = find_activity
    note = find_note(activity)

    note.assign_attributes(note_params)
    Source::Manage.(model: note, urls: params[:sources])

    if note.save
      render json: note
    else
      head 422
    end
  end

  def destroy
    activity = find_activity

    note = find_note(activity)
    note.soft_delete

    head 200
  end

  private

  def note_params
    params.permit(:title, :date, :text)
  end

  def find_activity
    Activity.find(params[:activity_id])
  end

  def find_note(activity)
    activity.notes.find(params[:id])
  end

end
