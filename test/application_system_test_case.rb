require "test_helper"
require "capybara/cuprite"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, using: :chromium, screen_size: [1400, 1400]

  def setup
    I18n.locale = :en
    visit locale_root_path
  end

end

class MobileSystemTestCase < ApplicationSystemTestCase
  driven_by :cuprite, using: :chromium, screen_size: [375, 666]

  private

end

