# A sample Gemfile
source 'https://rubygems.org'

# ruby version
ruby '2.2.2'

# web server
gem 'thin'

# web framework
gem 'sinatra'

# active record support
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'protected_attributes'

# json (de)serialization
gem 'json'

# data encryption
gem 'rbnacl-libsodium'

# manage environment variables
gem 'dotenv'

# view DSL support
gem 'haml'

group :development do
  gem 'sqlite3'
  gem 'tux'
end

group :test do
  gem 'rake'
  gem 'rack'
  gem 'rack-test'
  gem 'minitest'
end

group :production do
  gem 'pg'
end
