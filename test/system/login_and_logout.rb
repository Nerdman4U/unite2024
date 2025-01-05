require "application_system_test_case"

class LoginAndLogout < ApplicationSystemTestCase

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

end