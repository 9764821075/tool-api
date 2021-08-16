class YearValidator < ActiveModel::EachValidator

  INTEGER_REGEXP = /\A\d+\z/

  def validate_each(record, attribute, value)
    value_before_type_cast = record.public_send("#{attribute}_before_type_cast")

    if value_before_type_cast.to_s !~ INTEGER_REGEXP || value < 1900 || value > 3000
      record.errors.add(attribute, :invalid_year)
    end
  end

end
