Rails.application.config.after_initialize do
  uas = UaSetting.instance
  uas.sent_count = UNITE_SENT_COUNT
  uas.save

  Rails.application.config.version = uas.version

end
