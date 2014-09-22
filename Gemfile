source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'
gem 'bootstrap-sass', '2.3.2.0'
gem 'sprockets', '2.11.0'
gem 'bcrypt-ruby', '3.1.2'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.7'
gem 'bootstrap-will_paginate', '0.0.9'
gem 'mysql2'
#needed for windows
gem 'tzinfo-data'

group :development, :test do
  gem 'sqlite3', '1.3.9'
  gem 'rspec-rails', '3.0.2'
  # The following optional lines are part of the advanced setup.
  gem 'guard-rspec', '4.3.1'
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.1'
  gem 'childprocess', '0.5.3'
  gem 'spring'
end

group :test do
  gem 'selenium-webdriver', '2.42.0'
  gem 'capybara', '2.4.1'
  gem 'factory_girl_rails', '4.4.1'
  gem 'cucumber-rails', '1.4.1', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  #gem 'spork', '~> 0.9.2'

  # Uncomment this line on OS X.
  gem 'growl', '1.0.3'

  # Uncomment these lines on Linux.
  # gem 'libnotify', '0.8.0'

  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'win32console', '1.3.2'
  # gem 'wdm', '0.1.0'
end

gem 'bcrypt', '~> 3.1.7'
gem 'acts_as_list', '~> 0.4.0'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

group :doc do
  gem 'sdoc', '0.4.1', require: false
end

group :production do
  gem 'pg', '0.17.1'
  gem 'rails_12factor', '0.0.2'
end