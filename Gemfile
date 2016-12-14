source 'https://rubygems.org'

gem 'rails', '~> 4.2'
gem 'turbolinks', '~> 2.5'
gem 'jquery-rails'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'puma', require: false
gem 'sinatra', require: false
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'maestrano-connector-rails', '2.0.0.pre.RC12'

group :production, :uat do
  gem 'activerecord-jdbcmysql-adapter', platforms: :jruby
  gem 'mysql2', platforms: :ruby
  gem 'rails_12factor'
end

group :test, :development do
  gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby
  gem 'sqlite3', platforms: :ruby
  gem 'rubocop'
end

group :test do
  gem 'simplecov'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'timecop'
end

gem 'pipedrive-ruby', git: 'https://github.com/mehreen-tahir/pipedrive-ruby.git', :submodules => true
