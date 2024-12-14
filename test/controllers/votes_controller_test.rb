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
    assert_recognizes({ controller: "votes", action: "email_invite" }, { method: :post, path: "/votes/email_invite" })
    assert_routing({ method: :post, path: "/votes/email_invite" }, { controller: "votes", action: "email_invite" })
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
    # assert_redirected_to vote_path(locale: "en", secret_token: vote.secret_token)
    # assert flash[:success], "Thank you for your vote!"
    assert flash[:info], "Your vote is added but email is not yet confirmed. Please check your email."
    assert_redirected_to waiting_path(email: vote.email)
  end

  test "should not create vote if emails do not match" do
    values = {
      name: "foobar",
      email: "foobar1@foobar.com",
      email_repeat: "foobar2@foobar.com",
      ip: "0.0.0.0",
      country: "fi"
    }
    assert_no_difference("Vote.count") do
      post votes_path, params: { vote: values, "g-recaptcha-response": "valid" }
    end
    assert_equal flash[:warning], "Emails do not match"
    assert_redirected_to new_vote_path(locale: FastGettext.default_locale)
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
    # assert_redirected_to new_vote_path(locale: FastGettext.default_locale)
    assert_response :bad_request
  end

  # Xhr responses are now removed because i dont remember why they exists.
  test "should not create vote if ajax request" do
    values = {
      name: "foobar",
      email: "foobar1@foobar.com",
      email_repeat: "foobar1@foobar.com",
      country: "fi"
    }
    assert_no_difference("Vote.count") do
      post votes_path, params: { vote: values, "g-recaptcha-response": "valid" }, xhr: true
    end
    assert_response :gone
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

  test "should add parent vote id to session" do
    vote = votes("vote_1")
    post add_parent_vote_path, params: { token: vote.encoded_payload }
    assert_redirected_to new_vote_path(locale: "en")
    assert session[:parent_vote_id]
  end

  test "should add parent vote" do
    vote = votes("vote_1")
    post add_parent_vote_path, params: { token: vote.encoded_payload }

    values = {
      name: "foobar",
      email: "foobar02@foobar.com",
      email_repeat: "foobar02@foobar.com",
      country: "fi"
    }
    assert_difference("Vote.count") do
      post votes_path, params: { vote: values, "g-recaptcha-response": "valid" }
    end
    # puts "VotesControllerTest.create vote: " + assigns(:vote).inspect
    assert_equal assigns(:vote).vote_id, votes("vote_1").id
    assert_not session[:parent_vote_id]
  end

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
    options = {
      token: vote.encoded_payload,
      name: "Testaaja",
      email: "testi@yeah.foo",
      email_repeat: "testi@yeah.foo",
      language: "english",
      "g-recaptcha-response": "valid"
    }
    post email_invite_votes_path, params: options

    assert_response :success
    assert_equal I18n.locale, :en
    assert_equal flash[:success], "Invitation has been sent, thank you!"
  end

  test "should not send email invite with wrong repeat" do
    vote = votes("vote_1")
    options = {
      token: vote.encoded_payload,
      name: "Testaaja",
      email: "testi@yeah.foo",
      email_repeat: "testi2@yeah.foo",
      language: "english",
      "g-recaptcha-response": "valid"
    }
    post email_invite_votes_path, params: options

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
end
