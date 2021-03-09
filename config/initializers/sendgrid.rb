if Rails.env.development?
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              'smtp.sendgrid.net',
  port:                 465,
  domain:               'heroku.com',
  user_name:            'apikey',
  password:             ENV["SENDGRID_PASS"],
  authentication:       'plain',
  enable_starttls_auto: true 
}
elsif Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address:              'smtp.sendgrid.net',
    port:                 465,
    domain:               'heroku.com',
    user_name:            'apikey',
    password:             ENV["SENDGRID_PASS"],
    authentication:       'plain',
    enable_starttls_auto: true 
  }
end