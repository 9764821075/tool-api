class ApplicationSerializer < ActiveModel::Serializer
  include Refile::AttachmentHelper

  def attachment_path(*args)
    URI(attachment_url(*args)).path
  end
end
