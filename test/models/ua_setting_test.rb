require 'test_helper'

class UaSettingTest < ActionMailer::TestCase
  include ActionMailer::TestHelper

  test 'should send email' do
    uas = UaSetting.instance
    uas.sent_at = nil
    uas.vote_count = 0
    uas.save

    assert_emails 0
    assert_emails 1 do
      uas.send!
    end

    assert_not uas.sent_at.blank?
    assert_equal uas.vote_count, VoteCount.total
  end

end
