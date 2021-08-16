# Lower BCrypt password strength outside of production env for speed.
Rails.configuration.password_strength = Rails.env.production? ? 15 : 1
