class NoteJoin < ApplicationRecord

  soft_deleteable

  belongs_to :noteable, polymorphic: true
  belongs_to :note

end

# == Schema Information
#
# Table name: note_joins
#
#  id            :uuid             not null, primary key
#  deleted       :boolean          default(FALSE)
#  noteable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  note_id       :uuid
#  noteable_id   :uuid
#
# Indexes
#
#  index_note_joins_on_noteable_id_and_noteable_type  (noteable_id,noteable_type)
#
