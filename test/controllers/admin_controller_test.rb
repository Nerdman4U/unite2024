require "test_helper"
class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get admin page" do
    vote = votes("vote_1")
    assert vote.role.blank?
    get admin_path token: vote.encoded_payload
    assert_response :redirect

    vote.role = "admin"
    vote.save
    get admin_path token: vote.encoded_payload
    assert_response :success
  end

  test "should get admin page after login at another page without explicitely givin token" do
    vote = votes("vote_1")
    vote.role = "admin"
    vote.save
    get vote_path token: vote.encoded_payload
    assert_response :success

    get admin_path
    assert_response :success
  end

  test "should parse CSV- file" do
    vote = votes("vote_1")
    vote.role = "admin"
    vote.save
    get vote_path token: vote.encoded_payload

    votes_csv = fixture_file_upload("admin_csv", "text/plain")
    service = ActiveStorage::Blob.service
    key = 'votes_csv'
    service.upload(key, votes_csv)
    # service.download(key)
    # service.delete(key)

    assert_difference("Vote.count", 2) do
      post upload_votes_url(admin_csv: "votes_csv")
    end

    # TODO
    # assert_not ActionMailer::Base.deliveries.empty?
  end

  test "should not add votes if csv is nil" do
    vote = votes("vote_1")
    vote.role = "admin"
    vote.save
    get vote_path token: vote.encoded_payload

    admin_csv = nil
    assert_no_difference("Vote.count") do
      post upload_votes_url(admin_csv: admin_csv)
    end
    # assert ActionMailer::Base.deliveries.empty?
  end

  test 'should filter csv data' do
    vote = votes("vote_1")
    vote.role = "admin"
    vote.save
    get admin_path token: vote.encoded_payload

    votes_csv = fixture_file_upload("admin_csv", "text/plain")

    require "csv"
    data = CSV.parse(votes_csv)

    filtered = @controller.send(:filter_csv, data)
    # puts "filtered: #{filtered.inspect}"
    assert filtered
    assert_equal filtered.size, 2
  end
end