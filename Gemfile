source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'dotenv-rails', groups: [:development, :test]
gem 'rails', '~> 5.2.6'
gem 'pg'
gem 'pg_search'
gem 'activerecord-precounter'
gem 'active_model_serializers'
gem 'oj'
gem 'puma', '~> 3.11'
gem 'bcrypt', '~> 3.1.7'
gem 'ancestry'
gem 'yajl-ruby', require: 'yajl/json_gem'
gem 'foreman'
gem 'auto_strip_attributes'
gem 'redcarpet'
gem 'i18n_data'
gem 'secure_headers'
gem 'kaminari'

gem 'refile', "~> 0.7.0", require: 'refile/rails', git: 'https://github.com/refile/refile.git'
gem 'refile-mini_magick', "~> 0.2"
gem 'miro'
gem 'streamio-ffmpeg'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'brakeman', require: false
  # gem 'bundler-audit', require: false
  gem 'dawnscanner', require: false
  gem 'bullet'
  gem 'annotate'
end
