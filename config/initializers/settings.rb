if Class.const_defined? "UaSetting"
  uas = UaSetting.instance
  uas.sent_count = 100
  uas.save
end
