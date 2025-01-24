require 'ostruct'

class Slide
  def initialize(options)
    @options = options
  end
  def name
    @options[:name] || "Uninitialized <Slide>"
  end
  def res
    @options[:res]
  end
  def type
    @options[:type]
  end
  def default
    @options[:default]
  end
  def alt
    @options[:alt]
  end
  def decorators
    @options[:decorators] || []
  end
  def headers
    OpenStruct.new(@options[:headers] || {})
  end
  def css
    @options[:css] || {}
  end
  def css_classes
    css()[:classes] || []
  end
end

class Slider
  def initialize(options)
    @options = options
    @slides = []
  end
  def init()
      @slides = slides(options)
  end
  def options
    @options
  end
  def name
    @options[:name] || "Uninitialized <Slider>"
  end
  def slides
    @options[:slides].map { |slide| Slide.new(slide) }
  end
  def navigation
    @options[:navigation] || false
  end
  def fullscreen
    @options[:fullscreen] || true
  end
  def type
    @options[:type] || "standard"
  end
  def autoplay
    @options[:autoplay] || false
  end
  def autoplay_speed
    @options[:autoplay_speed] || 5000
  end
  def show_play_and_pause
    @options[:show_play_and_pause] || false
  end
  def start_fullscreen
    @options[:start_fullscreen] || false
  end
  def show_fullscreen_buttons
    @options[:show_fullscreen_buttons] || false
  end
  def show_next_and_previous
    @options[:show_next_and_previous] || false
  end

  ## public: Return Slider decorators.
  #
  # These are data-decorators values used at javascript classes.
  #
  # TODO: Decorator could be automatically added if needed subelements
  # are found.
  #
  # Returns an array of strings.
  def decorators
    @options[:decorators] || []
  end
  def headers
    OpenStruct.new(@options[:headers] || {})
  end

end