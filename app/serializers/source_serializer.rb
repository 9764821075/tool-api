class SourceSerializer < ApplicationSerializer
  attributes :id, :name, :url, :author, :text, :published_at

  attribute :resource do
    object.model_name.collection
  end
end
