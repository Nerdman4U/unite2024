require "test_helper"

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:one)
  end

  def setup
    session[:locale] = :en
  end

  test "should get new" do
    vote = votes("vote_1")
    session[:current_vote_id] = vote.id

    get :new
    assert_response :success
  end

  test "should create comment" do
    vote = votes("vote_1")
    session[:current_vote_id] = vote.id

    assert_difference("Comment.count") do
      post :create, params: { comment: {
        body: @comment.body,
        language: @comment.language,
        theme: "water",
        anonymous: true
      } }
    end

    assert flash[:success], ["Your comment has been sent"]
    assert_redirected_to vote_path(locale: "en", token: vote.encoded_payload)
  end

  test "should not create comment unless logged in" do
    assert_no_difference("Comment.count") do
      post :create, params: { comment: {
        body: @comment.body,
        language: @comment.language,
        theme: "water",
        anonymous: true
      } }
    end
    assert flash[:danger], ["You need to be logged in"]
    assert_redirected_to new_vote_path(locale: "en")
  end

  test "should not create comment if vote is not found" do
    vote = votes("vote_1")
    session[:current_vote_id] = vote.id
    vote.destroy

    assert_no_difference("Comment.count") do
      post :create, params: { comment: {
        body: @comment.body,
        language: @comment.language,
        theme: "water"
      } }
    end

    assert_equal flash[:danger], ["There was an error"]
    assert_redirected_to locale_root_path(locale: "en")
  end

  test "should not create comment if missing parameters" do
    vote = votes("vote_1")
    session[:current_vote_id] = vote.id

    assert_no_difference("Comment.count") do
      post :create, params: { comment: {
        body: @comment.body,
        language: "english",
        theme: nil
      } }
    end

    assert flash[:warning], "You need to select a theme before posting a comment"
    assert :bad_request
  end

  test "should create comment in arabic" do
    session[:locale] = :ar
    vote = votes("vote_1")
    session[:current_vote_id] = vote.id

    assert_difference("Comment.count") do
      post :create, params: { comment: {
        body: @comment.body,
        language: @comment.language,
        theme: "water"
      } }
    end

    assert flash[:success], _("Your comment has been sent")
    assert_redirected_to vote_path(locale: "ar", token: vote.encoded_payload)
    @comment.destroy
  end

end
