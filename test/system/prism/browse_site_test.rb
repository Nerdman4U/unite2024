require "application_system_test_case"

class BrowseSiteTest < ApplicationSystemTestCase

  def setup
    super
    @app = ApplicationPrism.new
  end

  test 'should visit landing page' do
    page = @app.welcome_index
    page.load
    assert_equal 'Home (Save the Planet - Unite the Armies)', page.title
    assert !page.secure?
    assert page.header.logo.present?
    assert page.footer

    assert_selector 'h1', text: 'Save the Planet'.upcase
    assert_no_selector 'header .mobile-navigation'
    assert_selector 'header .primary-navigation'
  end

  test 'should redirect landing from page without locale' do
    page = @app.without_locale
    page.load

    page = @app.welcome_index
    assert page.displayed?
    assert_equal 'Home (Save the Planet - Unite the Armies)', page.title
  end

  test 'should redirect locale root without locale' do
    page = @app.root
    page.load

    page = @app.welcome_index
    assert page.displayed?
    assert_equal 'Home (Save the Planet - Unite the Armies)', page.title
  end

  test 'should visit appeal page' do
    page = @app.welcome_appeal
    page.load
    assert_equal 'Appeal (Save the Planet - Unite the Armies)', page.title
    assert !page.secure?
    assert page.header.logo.present?
  end

  test 'should visit new vote page' do
    page = @app.votes_new
    page.load
    assert_equal 'New vote (Save the Planet - Unite the Armies)', page.title
    assert !page.secure?
    assert page.header.logo.present?
  end

  test 'should visit votes list' do
    page = @app.votes_index
    page.load
    assert_equal 'a List of votes (Save the Planet - Unite the Armies)', page.title
    assert !page.secure?
    assert page.header.logo.present?
  end

  test 'should visit new token page' do
    page = @app.welcome_index
    page.load
    page.footer.login_link.click
    assert_equal 'Login (Save the Planet - Unite the Armies)', page.title
    assert !page.secure?
    assert page.header.logo.present?
  end

  test 'should have a comment at welcome page' do
    page = @app.welcome_index
    page.load
    assert page.comment.present?
  end

end