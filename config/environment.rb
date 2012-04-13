# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Disqus::Application.initialize!

require 'gmail'

#sendgrid settings for gmail
#ActionMailer::Base.smtp_settings = {
#  :address => "smtp.gmail.com",
#  :port => 587,
#  :authentication => :plain,
#  :enable_starttls_auto => true,
#  :domain => "stalkninja.com",
#  :user_name => "comments",
#  :password => "comments123"
#}

#Amazon SES settings
ActionMailer::Base.smtp_settings = {
  :address => "email-smtp.us-east-1.amazonaws.com",
  :authentication => :login,
  :enable_starttls_auto => true,
  :domain => "stalkninja.com",
  :user_name => "AKIAJULRMQUKNAJSJQFA",
  :password => "AidZcHIcJzJHTJgzFLDSHtdtIioWqeSTqp7C1p8b/3g5"
}
