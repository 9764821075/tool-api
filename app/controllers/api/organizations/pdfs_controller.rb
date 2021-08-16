class Api::Organizations::PdfsController < ApplicationController

  def index
    organization = find_organization
    pdfs = organization.pdfs.order_by_date.includes(:source_joins, :sources)

    render json: paginate(pdfs)
  end

  def upload_spec
    organization = find_organization
    upload_spec = UploadSpec.(record: organization.pdfs.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    organization = find_organization
    pdf = organization.pdfs.build(pdf_params)
    Source::Manage.(model: pdf, urls: params[:sources])

    if organization.save
      render json: pdf
    else
      head 422
    end
  end

  def update
    organization = find_organization
    pdf = find_pdf(organization)

    pdf.assign_attributes(pdf_params)
    Source::Manage.(model: pdf, urls: params[:sources])

    if pdf.save
      render json: pdf
    else
      head 422
    end
  end

  def destroy
    organization = find_organization

    pdf_join = organization.pdf_joins.where(pdf_id: params[:id]).first
    pdf_join.soft_delete if pdf_join

    head 200
  end

  private

  def pdf_params
    params.permit(:file, :description)
  end

  def find_organization
    Organization.find(params[:organization_id])
  end

  def find_pdf(organization)
    organization.pdfs.find(params[:id])
  end

end
