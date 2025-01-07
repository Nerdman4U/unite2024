require "application_system_test_case"

class LoginAndLogoutTest < ApplicationSystemTestCase

  def setup
    @app = ApplicationPrism.new
  end

  test 'should be able to login' do
    page = @app.tokens_new
    page.load

    page.email.set 'user1@vote-example.com'
    page.submit.click

    page = @app.welcome_index
    assert page.displayed?
    assert page.flash.present?
    assert page.flash.success.present?
    assert page.footer.has_no_logout_link?
  end

  test 'should not be able to login with wrong credentials' do
    page = @app.tokens_new
    page.load

    page.email.set 'wrong1@vote-example.com'
    page.submit.click

    page = @app.welcome_index
    assert page.displayed?

    assert page.flash.present?
    assert page.flash.warning.present?
  end

  test 'should be able to show vote and logout' do
    vote = votes("vote_1")
    token = vote.encoded_payload
    page = @app.votes_show
    page.load(token: token)

    assert page.displayed?
    assert page.footer.has_logout_link?

    page.footer.logout_link.click

    page = @app.welcome_index
    assert page.displayed?
  end

end