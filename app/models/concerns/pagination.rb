module Pagination
  extend ActiveSupport::Concern

  DEFAULT_LIMIT = 35

  included do
    scope :paginated, -> (page) { offset((page - 1) * DEFAULT_LIMIT).limit(DEFAULT_LIMIT) }
  end
end
