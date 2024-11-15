require 'test_helper'

class UaSettingTest < ActiveSupport::TestCase

  test 'should send email' do
    uas = UaSetting.instance
    uas.sent_at = nil
    uas.vote_count = 0
    uas.save

    uas.send!

    assert_not uas.sent_at.blank?
    assert_equal uas.vote_count, VoteCount.total
    assert_not ActionMailer::Base.deliveries.empty?      
  end

end
