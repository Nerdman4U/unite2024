require 'test_helper'

class VotesControllerTest < ActionController::TestCase

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  def setup
    session[:locale] = :en
  end

  test 'should route' do
    assert_recognizes({:controller => 'votes', :action => 'index', :locale => "en"}, '/en/votes')

    @vote = votes("vote_1")
    @vote.email_confirmation = @vote.email
    @vote.save
    assert_recognizes({controller: 'votes', action: 'show', locale: 'en', secret_token: @vote.secret_token}, "/en/votes/#{@vote.secret_token}")

    assert_recognizes({:controller => 'votes', :action => 'email_invite'}, {method: :post, path: '/votes/email_invite'})
    assert_routing({method: :post, path: '/votes/email_invite'}, {controller: 'votes', action: 'email_invite'})
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  # /votes/recently_added
  test 'should get recent votes as json' do
    get :recently_added, format: :json, params: { locale: "en" }
    assert_response :success
    assert json_response.class == Array
    assert json_response[0]["id"]
  end

  test 'should route vote path with secret token' do
    @vote = votes("vote_1")
    @vote.email_confirmation = @vote.email
    @vote.save
    assert @vote.secret_token
    votes_path(secret_token: @vote.secret_token, locale: "en")
    assert_response :success
  end

  test "should create vote" do
    values = {
      name: "foobar",
      email: "foobar01@foobar.com",
      email_confirmation: "foobar01@foobar.com",
      country: "fi"
    }
    assert_difference("Vote.count") do
      post :create, params: { vote: values }
    end
    vote = assigns(:vote)
    assert_redirected_to vote_path(locale: "en", secret_token: vote.secret_token)
    assert flash[:success], "Thank you for your vote!"
  end

  test 'should send backup mail after creating vote' do
    uas = UaSetting.instance
    uas.sent_at = nil
    uas.vote_count = 0
    uas.sent_count = 3001
    uas.save

    VoteCount.clear_values

    assert_equal VoteCount.total, 3000

    values = {
      name: "foobar",
      email: "foobar01@foobar.com",
      email_confirmation: "foobar01@foobar.com",
      country: "fi"
    }
    #post :create, vote: values
    post :create, params: { vote: values }

    uas.reload
    assert_equal uas.vote_count, 3001
    assert_not ActionMailer::Base.deliveries.empty?
  end

  test 'should add parent vote id to session' do
    post :add_parent, params: { t: votes("vote_1").md5_secret_token }
    assert_redirected_to new_vote_path(locale: "en")
    assert session[:parent_vote_id]
  end

  test 'should add parent vote' do
    session[:parent_vote_id] = votes("vote_1").id
    values = {
      name: "foobar",
      email: "foobar02@foobar.com",
      email_confirmation: "foobar02@foobar.com",
      country: "fi"
    }
    assert_difference("Vote.count") do
      post :create, params: { vote: values }
    end
    assert_equal assigns(:vote).vote_id, votes("vote_1").id
    assert_not session[:parent_vote_id]
  end

  test "should flash error if invalid vote" do
    values = {
      name: "foobar",
      email: "foobar1@foobar.com",
      email_confirmation: "foobar2@foobar.com",
      country: "fi",
    }
    assert_no_difference("Vote.count") do
      post :create, params: { vote: values }
    end
  end

  test 'should return correct language code' do
    @request.headers["Accept-Language"] = "fi-FI"
    assert_equal "fi", @controller.send(:language_code)
  end

  test 'should return correct country code' do
    @request.headers["Accept-Language"] = "fi-FI"
    @request.params[:vote] = {:country => "BY"}
    assert_equal "BY", @controller.send(:country_code)

    @request.headers["Accept-Language"] = nil
    @request.params[:vote] = nil
    assert_nil @controller.send(:country_code)
  end

  test 'should send email invite' do
    require 'digest/md5'
    digest = Digest::MD5.hexdigest("secret1")
    options = {
      t: digest,
      name: "Testaaja",
      email: "testi@yeah.foo",
      language: "english"
    }
    post :email_invite, params: options
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal I18n.locale, :en
  end

  test 'should send email invite in arabic' do
    require 'digest/md5'
    digest = Digest::MD5.hexdigest("secret1")
    options = {
      t: digest,
      name: "Testaaja",
      email: "testi@yeah.foo",
      language: "arabic"
    }
    post :email_invite, params: options
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal I18n.locale, :en
  end

end
