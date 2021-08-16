class Source < ApplicationRecord
  include PgSearch::Model
  include Pagination

  pg_search_scope :search,
                  against: [:title, :author, :published_at],
                  ignoring: :accents,
                  using: {
                    tsearch: {
                      prefix: true
                    },
                  }

  auto_strip_attributes :title, :url, :author

  soft_deleteable has_many: [
    :source_joins,
    :photo_joins,
    :pdf_joins,
  ]

  belongs_to :sourceable, polymorphic: true, optional: true
  has_many :source_joins

  has_many :photo_joins, as: :photoable
  has_many :photos, through: :photo_joins

  has_many :pdf_joins, as: :pdfable
  has_many :pdfs, through: :pdf_joins

  validate :validate_url, if: -> source { source.url.present? }

  scope :order_by_usage, -> {
    order("source_joins_count DESC NULLS LAST, published_at DESC, id")
  }

  scope :order_by_date, -> {
    order("published_at DESC NULLS LAST, created_at DESC, id")
  }

  def name=(name)
    self.title = name
  end

  def name
    title
  end

  def known_service?
    service.present? && username.present?
  end

  def create_author_alias(author)
    SourceAuthor.create!(
      service:  service,
      username: username,
      author:   author
    )
  end

  def author_alias
    return unless known_service?

    SourceAuthor.where(
      service:  service,
      username: username
    ).first
  end

  def author_or_alias
    author_alias.try(:author) || author
  end

  def service
    analysis.service
  end

  def username
    analysis.username
  end

  def describe
    Describe.(
      url:    url,
      author: author_or_alias,
      title:  title
    )
  end

  def analysis
    Analyze.(url: url)
  end

  private

  def validate_url
    host = URI.parse(url).host
    errors.add(:url, :invalid) unless host
  rescue URI::InvalidURIError
    errors.add(:url, :invalid)
  end

end

# == Schema Information
#
# Table name: sources
#
#  id                 :uuid             not null, primary key
#  author             :string
#  deleted            :boolean          default(FALSE)
#  published_at       :date
#  source_joins_count :integer
#  text               :text
#  title              :string
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_sources_on_url  (url) UNIQUE
#
