ActionMailer::Base.smtp_settings = {
  user_name:            ENV['SENDGRID_USERNAME'],
  password:             ENV['SENDGRID_PASSWORD'],
  address:              ENV['SENDGRID_ADDRESS'],
  port:                 ENV['SMTP_PORT'],
  domain:               ENV['SMTP_DOMAIN'],
  enable_starttls_auto: ENV['SMTP_STARTTLS'],
  openssl_verify_mode:  ENV['SMTP_OPENSSL'],
  authentication:       ENV['SMTP_AUTH']
}
