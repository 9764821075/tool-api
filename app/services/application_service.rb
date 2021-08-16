class ApplicationService
  include ActiveModel::Validations

  def self.call(attributes = {})
    new(attributes).call
  end

  def initialize(attributes = {})
    attributes.each do |attribute, value|
      public_send(:"#{attribute}=", value)
    end
  end

  def t(*args)
    I18n.t(*args)
  end

end
