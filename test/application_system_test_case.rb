require "test_helper"
require "capybara/cuprite"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  driven_by :cuprite

end

class MobileSystemTestCase < ApplicationSystemTestCase
  def setup
    # Setup actions specific to mobile system tests can be added here
    resize_window_to_mobile
  end

  private

  def resize_window_to_mobile
    page.driver.browser.manage.window.resize_to(375, 667)
  end

end