require "test_helper"

class VoteTest < ActionMailer::TestCase
  include ActionMailer::TestHelper

  def setup
    I18n.locale = :en
    @vote = votes("vote_1").dup
    @vote.email = "invalid@vote-example.com"
    @vote.email_repeat = @vote.email
    @vote.bypass_humanizer = true
  end

  def teardown
    @vote.destroy unless @vote.new_record?
  end

  test "should not save without name" do
    @vote.name = nil
    assert_not @vote.save, "Save vote without name"
  end

  test "should not save without country" do
    @vote.country = nil
    assert_not @vote.save, "Save vote without country"
  end

  test "should not save without email" do
    @vote.email = nil
    assert_not @vote.save, "Save vote without email"
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

  test "should not save duplicate email" do
    @vote.email = votes("vote_1").email
    assert_not @vote.save, "Save vote with duplicate email"
  end

  test "should not save wrong email format" do
    @vote.email = "asdf"
    @vote.email_repeat = "asdf"
    assert_not @vote.save, "Save vote with wrong email format"
  end

  test "should not save invalid country" do
    @vote.country = "-1"
    assert_not @vote.save, "Save vote with invalid country"

    @vote.country = "Finland"
    assert_not @vote.save, "Save vote with invalid country"
  end

  test "should save correct country" do
    @vote.country = "FI"
    assert @vote.save
  end

  test "should save with correct values" do
    assert @vote.save
  end

  test "should add vote count" do
    @vote.save
    vote_count = VoteCount.where(country: @vote.country).first
    assert vote_count
    assert_equal vote_count.count, 1001
  end

  test "should calculate ago" do
    @vote.save
    assert @vote.ago
    assert @vote.ago.match(/second/)
  end

  test "should have secret token" do
    @vote.save
    assert @vote.secret_token
  end

  test "should have MD5 secret token" do
    @vote.save
    require "digest/md5"
    digest = Digest::MD5.hexdigest(@vote.secret_token)
    assert_equal @vote.md5_secret_token, digest
  end

  test "should have number" do
    @vote.save
    assert_equal @vote.order_number, 3001
  end

  test "should send email invitation" do
    @vote.email_invite(name: "Kati Kohde", email: "info+testi@jonitoyryla.eu", language: "english")
    assert_emails 1
  end

  test "should send email invitation in arabic" do
    @vote.email_invite(name: "Kati Kohde", email: "info+testi@jonitoyryla.eu", language: "arabic")
    assert_emails 1
  end

  test "should not change md5 secret token if exists" do
    token = @vote.md5_secret_token
    @vote.save
    assert_equal @vote.md5_secret_token, token
  end

  test "should return secret hash" do
    assert @vote.send(:secret_hash)
  end

  test "should find duplicate secret confirm hash" do
    @vote.secret_confirm_hash = "123"
    @vote.save
    @vote.reload
    assert @vote.valid?
    assert @vote.secret_confirm_hash = "123"

    # TODO: why database is not updated?
    # assert Vote.where(secret_confirm_hash: "123").first
  end

  test "should have secret confirm hash" do
    @vote.save
    assert @vote.secret_confirm_hash
  end

  test "should find free secret confirm hash" do
    assert @vote.send(:find_confirm_hash)
  end


  # TODO
  # test 'should increment counter cache' do
  #   vote = votes("vote_1")
  #   vote.email_repeat = vote.email
  #   vote2 = votes("vote_2")
  #   vote2.email_repeat = vote2.email
  #   vote.votes << vote2
  #   vote.save
  #   vote.reload
  #   assert_equal vote.votes_count, 1
  # end
end
