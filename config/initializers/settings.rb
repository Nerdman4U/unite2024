Rails.application.config.after_initialize do
  next unless UaSetting.table_exists?
  uas = UaSetting.instance
  if uas.blank?
    throw "UaSetting not found"
  end

  uas.sent_count = UNITE_SENT_COUNT
  uas.save

  Rails.application.config.version = uas.version

end
