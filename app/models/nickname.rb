class Nickname
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def initialize(attributes = {})
    attributes.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  attr_accessor :id, :value

  def persisted?
    !!@id
  end

end
