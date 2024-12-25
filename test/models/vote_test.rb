require "test_helper"

class VoteTest < ActionMailer::TestCase
  include ActionMailer::TestHelper

  def setup
    I18n.locale = :en
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

    # Multiple saves should not add vote count.
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

  test "should have order number" do
    @vote.save
    assert_equal @vote.order_number, 3001
  end

  test "should send email invitation" do
    votes("vote_1").invite(name: "Kati Kohde", email: "info+testi@jonitoyryla.eu", language: "english")
    assert_emails 1
  end

  test "should send email invitation in arabic" do
    votes("vote_1").invite(name: "Kati Kohde", email: "info+testi@jonitoyryla.eu", language: "arabic")
    assert_emails 1
  end

  test "should have votes to be send to admins" do
    # Vote.all.order(created_at: :asc).each do |vote|
    #   puts "#{vote.id} #{vote.created_at}"
    # end
    uas = UaSetting.instance
    uas.sent_at = nil
    uas.save
    # puts "VoteTest votes_from: #{Vote.votes_from} uas.sent_at: #{uas.sent_at}"
    votes = Vote.votes_to_be_send_to_admins
    # votes.each do |vote|
    #   puts "#{vote.id} #{vote.created_at}"
    # end
    assert votes
    assert_equal votes.size, 1000

    uas = UaSetting.instance
    uas.sent_at = Time.now - 1.year
    votes = Vote.votes_to_be_send_to_admins
    assert votes
    assert_equal votes.size, 12

    # Fixture votes are added once per month. All 12 should be in same year.
    assert_equal votes.map { |v| v.created_at.year }.uniq.size, 1
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
