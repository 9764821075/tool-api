class SourceJoin < ApplicationRecord

  soft_deleteable

  belongs_to :sourceable, polymorphic: true
  belongs_to :source, autosave: true, counter_cache: true

end

# == Schema Information
#
# Table name: source_joins
#
#  id              :uuid             not null, primary key
#  deleted         :boolean          default(FALSE)
#  sourceable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  source_id       :uuid
#  sourceable_id   :uuid
#
# Indexes
#
#  index_source_joins_on_sourceable_id_and_sourceable_type  (sourceable_id,sourceable_type)
#
