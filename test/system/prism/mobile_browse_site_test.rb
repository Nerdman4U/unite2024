require "application_system_test_case"

class MobileBrowseSiteTest < MobileSystemTestCase

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
    assert_selector 'header .mobile-navigation'
    assert_no_selector 'header .primary-navigation'
  end

end