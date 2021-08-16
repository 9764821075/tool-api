class NoteSerializer < ApplicationSerializer
  attributes :id, :title, :date, :text
  has_many :sources

end
