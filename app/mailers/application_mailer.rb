class ApplicationMailer < ActionMailer::Base
  default from: UNITE_CAMPAIGN_ASSISTANT_EMAIL
  layout "mailer"
end
