class PdfJoin < ApplicationRecord

  soft_deleteable

  belongs_to :pdfable, polymorphic: true
  belongs_to :pdf

end

# == Schema Information
#
# Table name: pdf_joins
#
#  id           :uuid             not null, primary key
#  deleted      :boolean          default(FALSE)
#  pdfable_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pdf_id       :uuid
#  pdfable_id   :uuid
#
# Indexes
#
#  index_pdf_joins_on_pdfable_id_and_type  (pdfable_id,pdfable_type)
#
