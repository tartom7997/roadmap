source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# before gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'rails', '~> 6.1.2'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
group :development do
  gem 'sqlite3', '~> 1.4'
end
group :production do
  gem 'pg'
  gem 'fog'
  # gem "fog-aws"
end
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
# gem 'sass-rails', '>= 6'
gem 'sassc-rails'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# jquery-rails
gem 'jquery-rails'

group :test do
  gem 'rails-controller-testing'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'guard'
  gem 'guard-minitest'
end

# japanese
gem 'rb-readline'

gem 'nokogiri'

# v2-3
# gem 'bootstrap-sass'

gem 'bcrypt'

gem 'faker'
gem 'will_paginate'
gem 'will_paginate-bootstrap4'
gem 'mail-iso-2022-jp'

gem 'carrierwave'
gem 'mini_magick'

gem 'rexml'

gem 'bootstrap', '~> 4.5.0'

# gem 'devise'
gem 'devise', git: "https://github.com/heartcombo/devise.git",  branch: "ca-omniauth-2"
# https://www.takayasugiyama.com/entry/2021/01/17/043512
# gem 'devise', github: 'heartcombo/devise'
gem 'omniauth'
# gem 'omniauth', '1.9.1'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'
gem 'dotenv-rails'            # 環境変数の管理
gem "omniauth-rails_csrf_protection"
gem 'bootstrap-social-rails'
gem 'font-awesome-rails'

gem 'sendgrid-ruby'
gem 'gretel'
gem 'mechanize'
gem 'meta-tags'