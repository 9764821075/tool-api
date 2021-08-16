module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def filter(filtering_params)
      results = self.where(nil)

      filtering_params.each do |key, value|
        results = results.public_send("filter_#{key}", value) if value.present?
      end

      results
    end
  end

end
