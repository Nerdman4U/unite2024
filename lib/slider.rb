class Slide
  def initialize(options)
    @options = options
  end
  def name
    @options[:name] || "Uninitialized <Slide>"
  end
  def captions
    {
      h1: @options[:h1],
      h2: @options[:h2],
      h3: @options[:h3],
      h4: @options[:h4],
      h5: @options[:h5],
    }
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