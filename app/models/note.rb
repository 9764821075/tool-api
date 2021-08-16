class Note < ApplicationRecord

  soft_deleteable has_many: [
    :source_joins,
  ]

  belongs_to :noteable, polymorphic: true, optional: true
  has_many :note_joins

  has_many :source_joins, as: :sourceable, autosave: true
  has_many :sources, through: :source_joins

  validate :title_or_text_present

  after_save { source_joins.reload }

  private

  def title_or_text_present
    if title.blank? && text.blank?
      errors.add(:title, "or text must be present")
      errors.add(:text, "or title must be present")
    end
  end

end

# == Schema Information
#
# Table name: notes
#
#  id         :uuid             not null, primary key
#  date       :date
#  deleted    :boolean          default(FALSE)
#  text       :text
#  title      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
