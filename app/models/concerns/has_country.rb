module HasCountry
  extend ActiveSupport::Concern

  def country=(value)
    if value
      self.country_code = value.fetch(:code)
    else
      self.country_code = nil
    end
  end

  def country
    return unless country_code.present?
    { code: country_code, name: I18nData.countries[country_code] }
  end

end
