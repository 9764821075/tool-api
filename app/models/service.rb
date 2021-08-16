class Service

  def self.services
    I18n.t("source.services").keys.map(&:to_s)
  end

end
