class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include SoftDeleteable

  def t(path, options = {})
    if path[0] == "."
      I18n.t("activerecord.attributes.#{model_name.singular}#{path}", options)
    else
      I18n.t(path, options)
    end
  end

end
