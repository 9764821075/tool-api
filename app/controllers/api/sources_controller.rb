class Api::SourcesController < ApplicationController

  def index
    page = params[:page].presence
    query = params[:query].presence
    order_by = params.fetch(:orderBy, 'references')

    records = Source

    if order_by == 'date'
      records = records.order_by_date
    else
      records = records.order_by_usage
    end

    all_record_count = records.count

    records = records.search(query) if query
    filtered_record_count = records.count

    records = records.paginated(page.to_i) if page

    render json: {
      allRecordCount: all_record_count,
      filteredRecordCount: filtered_record_count,
      records: records.map { |record|
        SourceIndexSerializer.new(record).as_json
      },
    }
  end

  def show
    render json: find_source
  end

  def create
    source = Source.new(create_source_params)

    if source.save
      render json: source
    else
      render json: source.errors, status: 422
    end
  end

  def update
    source = find_source

    if source.update(update_source_params)
      render json: source
    else
      head 422
    end
  end

  private

  def create_source_params
    params.permit(:name)
  end

  def update_source_params
    params.permit(:name, :author, :url, :published_at, :text)
  end

  def find_source
    Source.find(params[:source_id] || params[:id])
  end

end
