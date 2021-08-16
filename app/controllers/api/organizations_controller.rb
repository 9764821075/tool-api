class Api::OrganizationsController < ApplicationController

  def index
    page = params[:page].presence
    query = params[:query].presence

    records = Organization.order_by_ancestry.includes(:logo)
    all_record_count = records.count

    records = records.search(query) if query
    filtered_record_count = records.count

    records = records.paginated(page.to_i) if page

    render json: {
      allRecordCount: all_record_count,
      filteredRecordCount: filtered_record_count,
      records: records.map { |record|
        OrganizationIndexSerializer.new(record).as_json
      },
    }
  end

  def list
    records = Organization.order_by_name.includes(:logo)
    render json: records, each_serializer: OrganizationResourceSerializer
  end

  def show
    render json: find_organization
  end

  def create
    organization = Organization.new(create_organization_params)

    if organization.save
      render json: organization
    else
      render json: organization.errors, status: 422
    end
  end

  def update
    organization = find_organization

    if organization.update(update_organization_params)
      render json: organization
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    if organization.soft_delete
      render json: organization
    else
      head 422
    end
  end

  private

  def create_organization_params
    params.permit(:name, :shortname)
  end

  def update_organization_params
    params.permit(:name, :shortname)
  end

  def find_organization
    Organization.find(params[:organization_id] || params[:id])
  end

end
