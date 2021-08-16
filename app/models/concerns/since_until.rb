module SinceUntil
  extend ActiveSupport::Concern

  included do
    validates :since_month, month: true, allow_blank: true
    validates :until_month, month: true, allow_blank: true

    validates :since_year, year: true, allow_blank: true
    validates :until_year, year: true, allow_blank: true
  end

  def since
    { year: since_year.presence, month: since_month.presence }
  end

  def since=(value)
    self.since_month = value.fetch(:month)
    self.since_year = value.fetch(:year)
  end

  def until
    { year: until_year.presence, month: until_month.presence }
  end

  def until=(value)
    self.until_month = value.fetch(:month)
    self.until_year = value.fetch(:year)
  end

end
