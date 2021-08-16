class SourceIndexSerializer < ApplicationSerializer
  attributes :id, :title

  attribute :resource do
    "sources"
  end

  attribute :author do
    object.author_or_alias
  end

  attribute :service do
    object.service
  end

  attribute :username do
    object.username
  end

  attribute :host do
    object.analysis&.host
  end

  attribute :referenceCount do
    object.source_joins_count
  end

  attribute :publishedAt do
    object.published_at
  end
end
