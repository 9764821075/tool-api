class ApplicationController < ActionController::API

  def paginate(scope, default_per_page = 50)
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || default_per_page).to_i

    records = scope.page(page).per(per_page)
    current, total, per_page = records.current_page, records.total_pages, records.limit_value

    return {
      records: ActiveModel::Serializer::CollectionSerializer.new(records),
      pagination: {
        current:  current,
        previous: (current > 1 ? (current - 1) : nil),
        next:     (current == total ? nil : (current + 1)),
        per_page: per_page,
        pages:    total,
        count:    records.total_count
      }
    }
  end

end
