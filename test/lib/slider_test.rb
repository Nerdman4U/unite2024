require "test_helper"

class SliderTest < ActiveSupport::TestCase

  def setup
    @options = {
      name: "welcome",
      fullscreen: true,
      type: "standard",
      navigation: false,
      slides: [{
        name: "seascape",
        h1: "testi1",
        h2: "testi2",
        type: 'jpg',
        res: [640,960],
        default: 960,
        alt: "testikuva"
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
    assert_equal ["seascape"], slider.slides.map(&:name)
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
  test "should return captions" do
    slider = Slider.new(@options)
    assert_equal slider.slides[0].captions, {h1: "testi1", h2: "testi2", h3:nil, h4:nil, h5:nil}
  end
  test "should return slide image resolutions" do
    slider = Slider.new(@options)
    slide = slider.slides[0]
    assert_equal slide.res, [640,960]
  end
  test "should return slide image type" do
    slider = Slider.new(@options)
    slide = slider.slides[0]
    assert_equal slide.type, 'jpg'
  end
  test "should return slide image default resolution" do
    slider = Slider.new(@options)
    slide = slider.slides[0]
    assert_equal slide.default, 960
  end
  test "should return image alt text" do
    slider = Slider.new(@options)
    slide = slider.slides[0]
    assert_equal slide.alt, "testikuva"
  end
end


