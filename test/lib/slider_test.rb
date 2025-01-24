require "test_helper"

class SliderTest < ActiveSupport::TestCase

  def setup
    @slider_options = {
      name: "welcome",
      fullscreen: true,
      type: "standard",
      navigation: false,
      headers: {
        h1: ["testi 10"],
        h2: ["testi 20"],
      },
      slides: [{
        name: "seascape",
        css: {
          classes: ["testi-30"]
        },
        headers: {
          h1: ["testi 30"],
          h2: ["testi 40"],
        },
        type: 'jpg',
        res: [640,960],
        default: 960,
        alt: "testikuva",
        decorators: ['headers', 'image'],
      }]
    }

    @carousel_options = {
      name: "welcome-carousel",
      fullscreen: true,
      type: "carousel",
      navigation: false,
      decorators: ['headers', 'image'],
      headers: {
        h1: ["testi 11"],
        h2: ["testi 21"],
      },
      slides: [{
        name: "seascape",
        headers: {
          h1: ["testi 31"],
          h2: ["testi 41"],
        },
        res: [640,960,1024,1280,1920,2048,3072,4096],
        type: 'jpg',
        default: 640,
        alt: _(UNITE_TITLE),
        decorators: ['headers', 'image'],
      }
    ]}

    @slider = Slider.new(@slider_options)
    @carousel = Slider.new(@carousel_options)
  end

  test "slider exists" do
    assert_not_nil @slider
  end
  test "should return name" do
    assert_equal "welcome", @slider.name
  end
  test "should return slides" do
    assert_equal ["seascape"], @slider.slides.map(&:name)
  end
  test "should return fullscreen" do
    assert_equal true, @slider.fullscreen
  end
  test "should return type" do
    assert_equal "standard", @slider.type
    assert_equal "carousel", @carousel.type
  end
  test "should return navigation" do
    assert_equal false, @slider.navigation
  end
  test "should return headers" do
    assert @slider.headers[:h1].include? 'testi 10'
    assert @carousel.headers.h1.include? 'testi 11'
  end

  # SLIDE TESTS
  # TODO: slide_test
  test "should return slide image resolutions" do
    slide = @slider.slides[0]
    assert_equal slide.res, [640,960]
  end
  test "should return slide image type" do
    slide = @slider.slides[0]
    assert_equal slide.type, 'jpg'
  end
  test "should return slide image default resolution" do
    slide = @slider.slides[0]
    assert_equal slide.default, 960
  end
  test "should return image alt text" do
    slide = @slider.slides[0]
    assert_equal slide.alt, "testikuva"
  end
  test "should return slide decorators" do
    slide = @slider.slides[0]
    assert slide.decorators.include? "headers"
  end
  test "should return slide headers" do
    slide = @slider.slides[0]
    assert slide.headers[:h1].include? 'testi 30'

    assert slide.headers.h1.present?
    assert slide.headers.h3.blank?
  end

  test "should return css classes" do
    slide = @slider.slides[0]
    assert slide.css_classes.include? "testi-30"
  end

end


