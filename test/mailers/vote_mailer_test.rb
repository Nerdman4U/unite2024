# -*- coding: utf-8 -*-

require "test_helper"

class VoteMailerTest < ActionMailer::TestCase
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
    assert_equal "Thank you for signing the Unite the Armies petition", email.subject
    # assert_equal read_fixture('invite').join, email.body.to_s

    # Finnish letter
    I18n.locale = :fi
    vote = votes(:vote_1)
    email = VoteMailer.with(vote: vote).sign_up.deliver_now
    assert_emails 2
    assert_equal "Kiitokset allekirjoituksesta ja mahdollisuus auttaa", email.subject
  end

  # test "should send email invitations" do
  #   I18n.locale = :en
  #   vote = votes(:vote_1)
  #   VoteMailer.email_invite(inviter_name: "Kalle Kutsuja", name: "Joni Töyrylä", email: "info@jonitoyryla.eu", language: "english", token: vote.md5_secret_token).deliver_now
  #   assert_emails 1
  # end
  #
  #
  # test 'should send email invite in arabic' do
  #   require 'digest/md5'
  #   digest = Digest::MD5.hexdigest("secret1")
  #   options = {
  #     t: digest,
  #     name: "Testaaja",
  #     email: "testi@yeah.foo",
  #     language: "arabic"
  #   }
  #   assert_emails 0
  #   post email_invite_votes_path, params: options
  #   assert_emails 1
  #   assert_equal I18n.locale, :en
  # end

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
    VoteMailer.with(vote: vote, url: "http://example.com").confirmation.deliver_now
    assert_emails 1
  end
end
