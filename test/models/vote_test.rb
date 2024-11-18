require 'test_helper'

class VoteTest < ActiveSupport::TestCase

  def setup
    I18n.locale = :en
    @vote = votes("vote_1").dup
    @vote.email = "invalid@vote-example.com"
    @vote.email_confirmation = @vote.email
    @vote.bypass_humanizer = true
  end

  def teardown
    @vote.destroy unless @vote.new_record?
  end

  test 'should not save without name' do
    @vote.name = nil
    assert_not @vote.save, "Save vote without name"
  end

  test 'should not save without country' do
    @vote.country = nil
    assert_not @vote.save, "Save vote without country"
  end

  test 'should not save without email' do
    @vote.email = nil
    assert_not @vote.save, "Save vote without email"
  end

  test 'should not save without email_confirmation' do
    @vote.email_confirmation = nil
    assert_not @vote.save, "Save vote without email_confirmation"
  end

  # test 'should not save with short name' do
  #   # 16.9.2015/jto People can have very short names...
  #   #
  #   # @vote.name = "f"
  #   # assert_not @vote.save, "Save vote with too short name"
  #   # @vote.name = "fo"
  #   # assert_not @vote.save, "Save vote with too short name"
  #   # @vote.name = "foo"
  #   # assert_not @vote.save, "Save vote with too short name"
  # end

  test 'should not save with wrong email confirmation' do
    @vote.email_confirmation = "asdf@foobar.com"
    assert_not @vote.save, "Save vote with wrong email confirmation"
  end

  test 'should not save duplicate email' do
    @vote.email = votes("vote_1").email
    assert_not @vote.save, "Save vote with duplicate email"
  end

  test 'should not save wrong email format' do
    @vote.email = "asdf"
    @vote.email_confirmation = "asdf"
    assert_not @vote.save, "Save vote with wrong email format"
  end

  test 'should not save invalid country' do
    @vote.country = "-1"
    assert_not @vote.save, "Save vote with invalid country"

    @vote.country = "Finland"
    assert_not @vote.save, "Save vote with invalid country"
  end

  test 'should save correct country' do
    @vote.country = "FI"
    assert @vote.save
  end

  test 'should save with correct values' do
    assert @vote.save
  end

  test 'should add vote count' do
    @vote.save
    vote_count = VoteCount.where(country: @vote.country).first
    assert vote_count
    assert_equal vote_count.count, 1001
  end

  test 'should calculate ago' do
    @vote.save
    assert @vote.ago
    assert @vote.ago.match(/second/)
  end

  test 'should have secret token' do
    @vote.save
    assert @vote.secret_token
  end

  test 'should have MD5 secret token' do
    @vote.save
    require 'digest/md5'
    digest = Digest::MD5.hexdigest(@vote.secret_token)
    assert_equal @vote.md5_secret_token, digest
  end

  test 'should have number' do
    @vote.save
    assert_equal @vote.order_number, 3001
  end

  test 'should send email invitation' do
    @vote.email_invite(name: "Kati Kohde", email: "info+testi@unite-the-armies.org", language: "english")
    assert_not ActionMailer::Base.deliveries.empty?
  end

  # TODO
  # test 'should increment counter cache' do
  #   vote = votes("vote_1")
  #   vote.email_confirmation = vote.email
  #   vote2 = votes("vote_2")
  #   vote2.email_confirmation = vote2.email
  #   vote.votes << vote2
  #   vote.save
  #   vote.reload
  #   assert_equal vote.votes_count, 1
  # end

end
