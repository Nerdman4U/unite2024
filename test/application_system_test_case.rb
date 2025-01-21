require "test_helper"
require "capybara/cuprite"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, using: :chromium, screen_size: [1400, 1400]

  def setup
    I18n.locale = :en
    FastGettext.locale = :en
    visit locale_root_path
  end

end

class MobileSystemTestCase < ApplicationSystemTestCase
  # driven_by :cuprite, using: :chromium, screen_size: [375, 666]

  def setup
    Capybara.page.current_window.resize_to(375, 666)
    I18n.locale = :en
    FastGettext.locale = :en
    visit locale_root_path
  end

end

class HighResolutionSystemTestCase < ApplicationSystemTestCase

  def setup
    Capybara.page.current_window.resize_to(6000, 4000)
    I18n.locale = :en
    FastGettext.locale = :en
    visit locale_root_path
  end

end
