require "test_helper"
class WelcomeControllerTest < ActionDispatch::IntegrationTest


  def setup
    FastGettext.locale = :en
  end

  test "should get index" do
    get root_path
    assert_redirected_to "/en"

    get locale_root_path
    assert_response :success
  end

  test "should not be logged in" do
    get root_path
    assert_select ".navigation .logout", :count == 0
  end

  test "should be logged in" do
    vote = votes("vote_1")
    get vote_path(token: vote.encoded_payload)
    assert_response :success
    assert_select "header .logout"
    assert_select "header .logout" do |a|
      assert_equal a.text, _("Logout")
    end
  end

  test "should get index with default locale" do
    get root_path
    assert_equal I18n.locale, :en
  end

  test "should have correct title" do
    get locale_root_path
    assert_select "title", "Home (Save the Planet - Unite the Armies)"
  end

  test "should not get admin index with wrong hash" do
    get admin_index_url admin_hash: "foobar"
    assert_response :redirect
  end

end
