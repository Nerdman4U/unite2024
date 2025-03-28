# -*- coding: utf-8 -*-

require "test_helper"

class VoteMailerTest < ActionMailer::TestCase

  def setup
    I18n.locale = :en
  end

  test "should have sign up method" do
    assert VoteMailer.respond_to?(:sign_up)
  end

  test "should send sign up mail" do
    I18n.locale = :en
    vote = votes(:vote_1)
    email = VoteMailer.with(vote: vote).sign_up.deliver_now
    assert_emails 1

    # English letter
    assert_equal [ "info@jonitoyryla.eu" ], email.from
    assert_equal [ "user1@vote-example.com" ], email.to
    assert_equal "Thank you for signing the %{unite_title} petition" % {unite_title: UNITE_TITLE}, email.subject
    # assert_equal read_fixture('invite').join, email.body.to_s

    # Finnish letter
    I18n.locale = :fi
    vote = votes(:vote_1)
    email = VoteMailer.with(vote: vote).sign_up.deliver_now
    assert_emails 2
    assert_equal "Kiitokset allekirjoituksesta ja mahdollisuus auttaa", email.subject
  end

  test "should send email invitation" do
    vote = votes(:vote_1)
    options = { inviter_name: "Kalle Kutsuja", name: "Joni Töyrylä", email: "info@jonitoyryla.eu", language: "english", token: vote.public_token }
    VoteMailer.with(options: options).invite.deliver_now
    assert_emails 1
  end

  test 'should send email invite in arabic' do
    vote = votes(:vote_1)
    options = {
      inviter_name: "Kalle Kutsuja",
      name: "Testaaja",
      email: "testi@yeah.foo",
      language: "arabic",
      token: vote.public_token,
    }
    assert_emails 0
    VoteMailer.with(options: options).invite.deliver_now
    assert_emails 1
    assert_equal I18n.locale, :en
    # TODO: test that email is in arabic
  end

  test "should send new vote emails to admins" do
    uas = UaSetting.instance
    uas.sent_at = Time.now - 1.year

    # Vote.emails_to_admins
    votes = votes(:vote_1, :vote_2)
    VoteMailer.with(votes: votes).emails_to_admins.deliver_now

    uas = UaSetting.instance
    assert uas.sent_at < Time.now
    assert_emails 1
  end

  test "should send confirm vote email" do
    vote = votes(:vote_1)
    url = "http://example.com"
    confirm_url = "http://example.com/confirm"
    VoteMailer.with(vote: vote, url: url, confirm_url: confirm_url).confirmation.deliver_now
    assert_emails 1
  end

  test "should send token" do
    vote = votes(:vote_1)
    token = vote.encoded_payload
    VoteMailer.with(vote: vote, token: token).token.deliver_now
    assert_emails 1
  end
end
