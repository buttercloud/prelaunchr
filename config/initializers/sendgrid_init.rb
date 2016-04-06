require 'sendgrid-ruby'
SENDGRID_CLIENT = SendGrid::Client.new(api_key: ENV['SENDGRID_API_KEY'])
