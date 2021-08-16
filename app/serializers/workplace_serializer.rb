class WorkplaceSerializer < ApplicationSerializer
  attributes :id, :name, :position,
             :line1, :zip_code, :city, :country,
             :since, :until

end
