require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  # include ActionDispatch::Integration

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "should route" do
    vote = votes("vote_1")
    assert_recognizes({ controller: "votes", action: "index", locale: "en" }, "/en/votes")
    assert_recognizes({ controller: "votes", action: "show", locale: "en", token: vote.encoded_payload }, "/en/votes/#{vote.encoded_payload}")
    assert_recognizes({ controller: "votes", action: "invite" }, { method: :post, path: "/votes/invite" })
    assert_routing({ method: :post, path: "/votes/invite" }, { controller: "votes", action: "invite" })
  end

  test "should get new" do
    get new_vote_url
    assert_response :success
  end

  test "should get index" do
    get votes_url
    assert_response :success
  end

  # /votes/recently_added
  test "should get recent votes as json" do
    get recently_added_votes_path, params: { locale: "en", format: "json" }
    assert_response :success
    assert json_response.class == Array
    assert_not json_response.blank?
    assert json_response.size == 6
    assert json_response[0]["id"]
    assert json_response[0]["country"]
    assert json_response[0]["name"]
    assert json_response[0]["created_at"]
    assert json_response[0]["ago"]
    # uneven votes are not confirmed so it should not be returned
    assert_nil json_response.map { |x| x["name"] }.find { |n| n === "vote997" }
  end

  test "should route vote path with secret token" do
    @vote = votes("vote_1")
    @vote.email_confirmation = @vote.email
    @vote.save
    assert @vote.secret_token
    get votes_path(secret_token: @vote.secret_token, locale: "en")
    assert_response :success
  end

  test "should create vote" do
    values = {
      name: "foobar",
      email: "foobar01@foobar.com",
      email_repeat: "foobar01@foobar.com",
      country: "fi"
    }
    assert_difference("Vote.count") do
      post votes_path, params: { vote: values, "g-recaptcha-response": "valid" }
    end
    vote = assigns(:vote)

    assert flash[:info], "Your vote is added but email is not yet confirmed. Please check your email."
    assert_redirected_to waiting_path(locale: "en", token: vote.public_token)
  end

  test "should not create vote if emails do not match" do
    values = {
      name: "foobar",
      email: "foobar1@foobar.com",
      email_repeat: "foobar2@foobar.com",
      country: "fi"
    }
    assert_no_difference("Vote.count") do
      post votes_path, params: { vote: values, "g-recaptcha-response": "valid" }
    end
    assert_equal flash[:warning], "Emails do not match"
    assert_redirected_to new_vote_path(locale: "en")
  end

  test "should not create vote if email is invalid" do
    values = {
      name: "foobar",
      email: "foobar1",
      email_repeat: "foobar1",
      country: "fi"
    }

    assert_no_difference("Vote.count") do
      post votes_path, params: { vote: values, "g-recaptcha-response": "valid" }
    end

    assert_equal flash[:warning], "Email is invalid"
    assert_redirected_to new_vote_path(locale: "en")
  end

  # test 'should send backup mail after creating vote' do
  #   uas = UaSetting.instance
  #   uas.sent_at = nil
  #   uas.vote_count = 0
  #   uas.sent_count = 3001
  #   uas.save

  #   VoteCount.clear_values

  #   assert_equal VoteCount.total, 3000

  #   values = {
  #     name: "foobar",
  #     email: "foobar01@foobar.com",
  #     email_repeat: "foobar01@foobar.com",
  #     country: "fi"
  #   }
  #   post :create, params: { vote: values }

  #   uas.reload
  #   assert_equal uas.vote_count, 3001
  #   #assert_not ActionMailer::Base.deliveries.empty?
  #   assert_emails 1
  # end

  # test 'should return correct language code' do
  #   #@request.headers["Accept-Language"] = "fi-FI"
  #   #assert_equal "fi", @controller.send(:language_code)
  #   get votes_path(:headers => { "Accept-Language" => "fi-FI" })

  # end

  # test 'should return correct country code' do
  #   @request.headers["Accept-Language"] = "fi-FI"
  #   @request.params[:vote] = {:country => "BY"}
  #   assert_equal "BY", @controller.send(:country_code)

  #   @request.headers["Accept-Language"] = nil
  #   @request.params[:vote] = nil
  #   assert_nil @controller.send(:country_code)
  # end

  test "should send email invite" do
    vote = votes("vote_1")
    get vote_path(locale: "en", token: vote.encoded_payload)

    options = {
      token: vote.md5_secret_token,
      name: "Testaaja",
      email: "testi@yeah.foo",
      email_repeat: "testi@yeah.foo",
      language: "english",
      "g-recaptcha-response": "valid"
    }
    post invite_path, params: options

    assert_redirected_to vote_path(locale: "en", token: vote.encoded_payload)
    assert_equal I18n.locale, :en
    assert_equal flash[:success], "Invitation has been sent, thank you!"
  end

  test "should not send email invite with wrong repeat" do
    vote = votes("vote_1")
    get vote_path(locale: "en", token: vote.encoded_payload)

    options = {
      token: vote.encoded_payload,
      name: "Testaaja",
      email: "testi@yeah.foo",
      email_repeat: "testi2@yeah.foo",
      language: "english",
      "g-recaptcha-response": "valid"
    }
    post invite_path, params: options

    assert_response :redirect
    assert_equal I18n.locale, :en
    assert_nil flash[:success]
    assert_equal flash[:warning], "Emails do not match"
  end

  test "should confirm email address" do
    vote = votes("vote_1")
    get confirm_url(token: vote.encoded_payload)
    assert_redirected_to vote_path(locale: "en", token: vote.encoded_payload)
  end

  test "should get waiting page" do
    vote = votes("vote_1")
    vote.email_confirmed = nil
    vote.save

    # Should not print waiting time flash when get waiting_url first time.
    get waiting_url token: vote.public_token
    assert css_select(".alert").blank?

    sleep 1

    # Should get flash when get waiting_url second time.
    get waiting_url token: vote.public_token

    assert_response :success
    assert_dom ".alert" do
      assert_dom ".alert-heading", text: /^Please wait/
    end
  end

  test "should have proper title in english" do
    vote = votes("vote_1")

    # ROOT
    get root_path
    assert_dom "title", text: "Home (Save the Planet - Unite the Armies)"
    get locale_root_path
    assert_dom "title", text: "Home (Save the Planet - Unite the Armies)"

    # VOTES
    get votes_path #  without locale goes to root path
    assert_dom "title", text: "Home (Save the Planet - Unite the Armies)"

    get vote_path(locale: "en", token: vote.encoded_payload)
    assert_dom "title", text: "My vote (Save the Planet - Unite the Armies)"

    get votes_path(locale: "en")
    assert_dom "title", text: "List of votes (Save the Planet - Unite the Armies)"

    get new_vote_path(locale: "en")
    assert_dom "title", text: "New vote (Save the Planet - Unite the Armies)"

    # COMMENTS
    get new_comment_path
    assert_dom "title", text: "New comment (Save the Planet - Unite the Armies)"

  end
end
