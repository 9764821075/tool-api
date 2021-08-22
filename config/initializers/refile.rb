Refile.types[:video] = Refile::Type.new(:video, content_type: %w[video/mp4])
Refile.types[:pdf] = Refile::Type.new(:pdf, content_type: %w[application/pdf])
Refile.types[:zip] = Refile::Type.new(:zip, content_type: %w[application/zip])

unless Rails.env.production?
  Refile.app_host = "http://localhost:3000"
end

Refile.secret_key = "ae6180212d9d363fd6c632f66c78f140cf330d84ae52ead18d17240322db0896ddb458e4127ae5cfccf19ec6879bd6b207c83751b1bd5ee80520d9f72ce09a25"

storage_path = Rails.root.join("storage")
Refile.cache = Refile::Backend::FileSystem.new(storage_path.join("cache").to_s)
Refile.store = Refile::Backend::FileSystem.new(storage_path.join("store").to_s)
