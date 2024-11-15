require 'test_helper'

class CountryTest < ActiveSupport::TestCase

  test 'should return country list from disc' do
    assert Country.from_disc
    assert Country.from_disc.size === 244
  end

  test 'should reverse array for select tag' do
    assert Country.for_select[0][0] == "Afghanistan"
  end

end
