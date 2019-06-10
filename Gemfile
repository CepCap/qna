source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'

#initial rails gems
gem 'rails', '~> 5.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

#custom gems
gem 'decent_exposure', '3.0.0'
gem 'slim-rails'
gem 'devise'
gem 'bootstrap'
gem 'jquery-rails'
gem 'cocoon'
gem 'skim'
gem 'gon'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'oj'
gem 'whenever', require: false
gem 'mysql2', '~> 0.5.2'
gem 'thinking-sphinx'
gem 'mini_racer'
gem 'aws-sdk-s3'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~>3.8'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano-ssh-doctor', git: 'https://github.com/capistrano-plugins/capistrano-ssh-doctor.git'
  gem 'capistrano-rbenv'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'capybara-email'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
