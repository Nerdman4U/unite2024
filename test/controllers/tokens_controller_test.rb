require "test_helper"

class TokensControllerTest < ActionDispatch::IntegrationTest
  test "should get new token" do
    get new_token_url
    assert_response :success
  end

  test "should create token" do
    post tokens_url(email: votes("vote_1").email)

    assert_response :redirect
    assert_redirected_to locale_root_path
    follow_redirect!

    assert_dom ".alert" do
      assert_dom ".alert-heading", text: /^Your private link has been sent to your email/
    end
  end
end
