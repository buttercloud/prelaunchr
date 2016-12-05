require 'sendgrid-ruby'
SENDGRID_CLIENT = SendGrid::Client.new(api_key: ENV['SENDGRID_API_KEY'])
SENDGRID_TEMPLATE_IDS = { welcome_email: "e2cde2ba-828d-422d-80f1-fc874ca93e33", 
                          referral_email: "821c2020-f0f1-483c-a338-38b7c1e0c821" } 
