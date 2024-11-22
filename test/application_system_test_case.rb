require "test_helper"
require "capybara/cuprite"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  #driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  driven_by :cuprite
end
