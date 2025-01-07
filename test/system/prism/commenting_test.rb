require "application_system_test_case"

class CommentingTest < ApplicationSystemTestCase

  def setup
    @app = ApplicationPrism.new
  end

  def login
    page = @app.votes_show
    page.load(token: token)
    assert page.displayed?
  end

  def token
    vote = votes("vote_1")
    vote.encoded_payload
  end

  test 'should not be able to visit comment page without login' do
    page = @app.comments_new
    page.load
    assert !page.displayed?
  end

  test 'should be able to visit comment page after login' do
    login
    page = @app.comments_new
    page.load
    assert page.displayed?
  end

  test 'should be able to send a comment' do
    login
    page = @app.comments_new
    page.load

    page.language_english.click
    page.theme_administration.click

    assert_equal page.comment_conclusion.text, "Your comment is about administration, and it is written in English."
    assert_equal page.comment_description.text, "The activities of the United Armies must be controlled by a common, international organ."

    page.comment_body.set "This is a comment."
    page.comment_submit.click

    page = @app.votes_show

    #TODO: page.load without token => "page.displayed?" is false?
    #assert page.displayed?
    assert page.flash.success.text.include?("Your comment has been sent".upcase)
  end

end