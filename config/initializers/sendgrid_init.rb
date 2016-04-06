require 'sendgrid-ruby'
SENDGRID_CLIENT = SendGrid::Client.new(api_key: SENDGRID_API_KEY)
