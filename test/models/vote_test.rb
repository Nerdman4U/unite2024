require "test_helper"

class VoteTest < ActiveSupport::TestCase

  def setup
    I18n.locale = :en

    # This is new record.
    @vote = votes("vote_1").dup
    @vote.email = "invalid@vote-example.com"
    @vote.email_repeat = @vote.email
    @vote.bypass_humanizer = true

    uas = UaSetting.instance
    uas.sent_at = Vote.first.created_at
    uas.save
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

  test "should find with spam scope" do
    assert Vote.count > 0
    assert Vote.spam.count == 0
    assert Vote.unspam.count > 0, "All votes where spam?"
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

  test "should add vote count after confirm" do
    vote = votes("vote_2")
    vote.confirm!
    assert 1, VoteCount.where(country: @vote.country).first.count
  end

  test "should not add vote count if not confirmed" do
    assert_nil Vote.maximum(:order_number)
    count_before = VoteCount.where(country: @vote.country).first.count
    vote = Vote.new({name: "testi", email: "info@email.test", country: "fi", ip: "1.1.1.1"})
    vote.save

    assert !vote.new_record?
    assert_nil vote.email_confirmed
    assert_equal vote.order_number, 1
    assert_equal 1000, count_before
  end

  test "should add order number" do
    bef = VoteCount.where(country: @vote.country).first.count
    @vote.save
    assert_equal @vote.order_number, 1
    assert 0, VoteCount.where(country: @vote.country).first.count

    # Multiple saves should not add vote count.
    @vote.save
    assert_equal @vote.order_number, 1
    assert 1, VoteCount.where(country: @vote.country).first.count
  end

  test "should calculate ago" do
    vote = votes("vote_1")
    assert vote.created_at
    assert vote.ago

    vote.created_at = Time.now + 1.minute
    vote.save
    assert_equal vote.ago, "Now"

    vote.created_at = Time.now - 3.seconds
    vote.save
    assert_equal vote.ago, "Now"

    vote.created_at = Time.now - 40.seconds
    vote.save
    assert_equal vote.ago, "40 seconds"

    vote.created_at = Time.now - 30.minutes
    vote.save
    assert_equal vote.ago, "30 minutes"

    vote.created_at = Time.now - 3.hours
    vote.save
    assert_equal vote.ago, "3 hours"

    vote.created_at = Time.now - 3.hours - 30.minutes
    vote.save
    # assert_equal vote.ago, "3 hours 30 minutes"
    assert_equal vote.ago, "3 hours"

    vote.created_at = Time.now - 3.hours - 60.minutes
    vote.save
    assert_equal vote.ago, "4 hours"

    vote.created_at = Time.now - 23.hours
    vote.save
    assert_equal vote.ago, "23 hours"

    vote.created_at = Time.now - 1.day
    vote.save
    assert_equal vote.ago, "Yesterday"

    vote.created_at = Time.now - 1.day - 4.hours
    vote.save
    assert_equal vote.ago, "Yesterday"

    vote.created_at = Time.now - 1.day - 23.hours
    vote.save
    assert_equal vote.ago, "Yesterday"

    vote.created_at = Time.now - 3.days
    vote.save
    assert_equal vote.ago, "3 days"

    vote.created_at = Time.now - 3.days - 23.hours
    vote.save
    assert_equal vote.ago, "3 days"

    vote.created_at = Time.now - 7.days
    vote.save
    assert_equal vote.ago, "7 days"

    vote.created_at = Time.now - 8.days
    vote.save
    assert_equal vote.ago, "More than a week."
  end

  test "should have secret token" do
    @vote.save
    assert @vote.secret_token
    assert @vote.md5_secret_token
    # assert_nil @vote.secret_confirm_hash
  end

  test "should get encoded payload" do
    encoded_payload = votes("vote_1").encoded_payload
    assert encoded_payload

    # JWT.decode is used at token_helper.rb
    decoded = JWT.decode(encoded_payload, ENV["UNITE_SECRET_KEY"], true, algorithm: "HS256")[0]
    assert decoded["vote_id"], votes("vote_1").id

    # should get same payload as before
    encoded_payload2 = votes("vote_1").encoded_payload
    assert_equal encoded_payload, encoded_payload2
  end

  test "should have order number after save" do
    @vote.save
    assert_equal @vote.order_number, 1
  end

  test "should send email invitation" do
    assert votes("vote_1").invite(name: "Kati Kohde", email: "info+testi@jonitoyryla.eu", language: "english")
    end

  test "should send email invitation in arabic" do
    assert votes("vote_1").invite(name: "Kati Kohde", email: "info+testi@jonitoyryla.eu", language: "arabic")
  end

  test "should have child and parent votes" do
    vote1 = votes("vote_1")
    vote2 = votes("vote_2")

    assert_equal vote1.votes.size, 0
    assert_nil vote2.vote

    vote1.votes << vote2

    assert_equal vote1.votes.size, 1
    assert_equal vote2.vote, vote1
  end

  test "should make private token" do
    assert votes("vote_1").send(:make_private_token)
    assert_equal votes("vote_1").send(:make_private_token).size, 12
  end

  test "should make public token from private" do
    require 'digest/md5'

    vote = votes("vote_1")
    private_token = vote.send(:make_private_token)
    public_token = vote.send(:make_public_token, private_token)

    assert_equal public_token, Digest::MD5.hexdigest(private_token)
  end

  test "should have private and public token in database" do
    vote = votes("vote_1")
    assert vote.send(:private_token)
    assert vote.send(:public_token)
  end

  test "should return roles" do
    vote = votes("vote_1")
    assert_nil vote.role
    assert_equal vote.roles, []

    vote.role = "admin"
    vote.save
    assert_equal vote.roles, [:admin]

    vote.role = " a b   "
    vote.save
    assert_equal vote.roles, [:a, :b]
  end

  test "should be admin" do
    vote = votes("vote_1")
    vote.role = "admin"
    assert vote.admin?
    vote.role = "user"
    assert_not vote.admin?
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
