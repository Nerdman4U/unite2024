require "test_helper"

class SliderTest < ActiveSupport::TestCase

  def setup
    @options = {
      name: "welcome",
      fullscreen: true,
      type: "standard",
      navigation: false,
      slides: [{
        name: "seashore"
      }]
    }
  end
  test "slider exists" do
    slider = Slider.new(@options)
    assert_not_nil slider
  end
  test "should return name" do
    slider = Slider.new(@options)
    assert_equal "welcome", slider.name
  end
  test "should return slides" do
    slider = Slider.new(@options)
    assert_equal ["seashore"], slider.slides.map(&:name)
  end
  test "should return fullscreen" do
    slider = Slider.new(@options)
    assert_equal true, slider.fullscreen
  end
  test "should return type" do
    slider = Slider.new(@options)
    assert_equal "standard", slider.type
  end
  test "should return navigation" do
    slider = Slider.new(@options)
    assert_equal false, slider.navigation
  end

end


