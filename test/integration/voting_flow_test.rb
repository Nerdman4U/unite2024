require "test_helper"

class VotingFlowTest < ActionDispatch::IntegrationTest
  def setup
  end

  test "can find voting button" do
    get locale_root_path
    assert_response :success
    assert_select "h1", "Save the planet"
    assert_select ".button", "Support now"
  end

  test "can go to voting page" do
    get new_vote_path
    assert_response :success
  end

  test "can vote and confirm" do
    post create_vote_path, params: { vote: { name: "John Doe", email: "jdoe@localhost", email_repeat: "jdoe@localhost", country: "fi" } }
    assert flash[:info].present?
    assert_equal flash[:info], ["Your vote is added but email is not yet confirmed. Please check your email."]
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Confirm email sent"

    vote = Vote.last
    assert_equal vote.name, "John Doe"

    get confirm_path(token: vote.encoded_payload)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Thank you for your support John Doe"
  end

  test "can logout" do
    # 1. add vote_id to session
    # 2. get vote#show
    # 3. get logout_path
    # 4. fail to get vote#show

    # TODO: how to access session while testing?
    # session = open_session <= not working

    delete logout_path
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Save the planet"
  end
end
