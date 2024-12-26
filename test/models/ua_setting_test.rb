require "test_helper"

class UaSettingTest < ActiveSupport::TestCase

  def setup
    Rails.configuration.x.votes_in_notify_email = 100
  end

  test "should count votes after last notify email" do
    uas = UaSetting.instance
    uas.sent_at = nil
    uas.save
    votes = uas.votes_after_notify
    assert_equal votes.size, Vote.count

    uas.sent_at = Time.now - 1.year
    uas.save
    votes = uas.votes_after_notify
    assert_equal votes.size, 12
  end

  test "should not send notify email if votes are not enough" do
    votes = Vote.where("created_at > ?", Time.now - 1.year).order(created_at: :desc)
    uas = UaSetting.instance
    uas.sent_at = votes.last.created_at - 1.day
    uas.save

    assert_equal uas.votes_after_notify.size, 12
    assert_not uas.send_notify_email?
  end

  test "should send notify email if votes are enough" do
    votes = Vote.where("created_at > ?", Time.now - 1.year).order(created_at: :desc)
    uas = UaSetting.instance
    uas.sent_at = votes.last.created_at - 1.day
    uas.save

    Rails.configuration.x.votes_in_notify_email = 12
    assert_equal uas.votes_after_notify.size, 12
    assert uas.send_notify_email?
  end

  test "should modify sent_at after sending notify email" do
    uas = UaSetting.instance
    uas.sent_at = nil
    uas.save

    assert uas.send_notify_email!

    uas = UaSetting.instance
    assert uas.sent_at
  end

end
