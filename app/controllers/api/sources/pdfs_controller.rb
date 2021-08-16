class Api::Sources::PdfsController < ApplicationController

  def index
    source = find_source
    pdfs = source.pdfs.includes(:source_joins, :sources)

    render json: paginate(pdfs)
  end

  def upload_spec
    source = find_source
    upload_spec = UploadSpec.(record: source.pdfs.build, method: :file, host: request.url)

    render json: upload_spec
  end

  def create
    source = find_source
    pdf = source.pdfs.build(pdf_params)
    Source::Manage.(model: pdf, urls: params[:sources])

    if source.save
      render json: pdf
    else
      head 422
    end
  end

  def update
    source = find_source
    pdf = find_pdf(source)

    pdf.assign_attributes(pdf_params)
    Source::Manage.(model: pdf, urls: params[:sources])

    if pdf.save
      render json: pdf
    else
      head 422
    end
  end

  def destroy
    source = find_source

    pdf_join = source.pdf_joins.where(pdf_id: params[:id]).first
    pdf_join.soft_delete if pdf_join

    head 200
  end

  private

  def pdf_params
    params.permit(:file, :description)
  end

  def find_source
    Source.find(params[:source_id])
  end

  def find_pdf(source)
    source.pdfs.find(params[:id])
  end

end
