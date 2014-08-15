ActionMailer::Base.smtp_settings = {
 :address              => "smtp.163.com",
 :port                 => 25,
 :domain               => "163.com",
 :user_name            => "username",
 :password             => "password",
 :authentication       => "login",
 :enable_starttls_auto => true
}
ActionMailer::Base.raise_delivery_errors = true
