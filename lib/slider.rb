class Slide
  def initialize(options)
    @options = options
  end
  def name
    @options[:name] || "Uninitialized <Slide>"
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

end