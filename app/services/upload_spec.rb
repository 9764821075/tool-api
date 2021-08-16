class UploadSpec < ApplicationService

  attr_accessor :record, :method, :host

  def call
    result = {}
    definition = record.send(:"#{method}_attachment_definition")

    # direct
    url = Refile.attachment_upload_url(record, method)
    result.merge!(direct: true, url: url)

    # presign
    if definition.cache.respond_to?(:presign)
      url = Refile.attachment_presign_url(record, method, host: host)
      result.merge!(direct: true, presigned: true, url: url)
    end

    result
  end

end
