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
  def autoplaySpeed
    @options[:autoplayspeed] || 5000
  end
  def showPlayAndPause
    @options[:showplayandpause] || false
  end
  def startFullScreen
    @options[:startfullscreen] || false
  end
  def showFullScreenButtons
    @options[:showfullscreenbuttons] || false
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