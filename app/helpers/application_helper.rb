module ApplicationHelper
  def flash_messages
    # flash[:success] = [_("There was a success")] || flash[:success] << _("There was a success")
    # flash[:success] << _("There was a success")
    # flash[:warning] = [_("There was a warning")]
    # flash[:danger] = [_("There was a danger")]
    # flash[:info] = [_("There was an info")]

    content_tag :div, class: "flash_container" do
      final = ApplicationController::FLASH_TYPES.map do |type|
        next unless flash[type].present?
        result = tag.ul class: "alert-#{type}", role: "alert" do
          flash[type].map do |msg|
            tag.li class: "h2", onClick: "$(this).hide()" do msg end
          end.join.html_safe
        end.html_safe
      end.join.html_safe
    end.html_safe
  end

  ## Link to Token
  #
  def link_to_token
    link_to new_token_url, class: "login" do
      # tag.i class: "bi bi-flower1", title: _("To your private vote")
      _("My vote")
    end
  end

  def link_to_vote
    unless logged_in? && vote = current_vote
     return link_to_token
    end

    token = vote.encoded_payload
    link_to vote_url(token: token), class: "my-vote" do
      # tag.i class: "bi bi-chat-square", title: _("Your private vote")
      _("My vote")
    end
  end

  def link_to_logout
    link_to logout_url, method: :delete, class: "logout" do
      # tag.i class: "bi bi-box-arrow-right", title: _("Logout")
      _("Logout")
    end
  end

  def button_black
    "button-black up-2 text-uppercase ufs-2 shadow border border-2 border-light rounded text-decoration-none"
  end

  def button_white
    "button-white up-2 text-uppercase ufs-2 shadow border border-2 border-dark rounded text-decoration-none"
  end

  def vimeo_stuff
    if locale == :fi
      url = "https://player.vimeo.com/video/153508732?autoplay=false"
      video_id = "153508732"
    elsif locale == :es
      url = "https://player.vimeo.com/video/153508813?autoplay=false"
      video_id = "153508813"
    elsif locale == :zh
      url = "https://player.vimeo.com/video/153508814?autoplay=false"
      video_id = "153508814"
    elsif locale == :ru
      url = "https://player.vimeo.com/video/153508816?autoplay=false"
      video_id = "153508816"
    elsif locale == :fr
      url = "https://player.vimeo.com/video/153508812?autoplay=false"
      video_id = "153508812"
    elsif locale == :ar
      url = "https://player.vimeo.com/video/160513218?autoplay=false"
      video_id = "160513218"
    else
      url = "https://player.vimeo.com/video/153508772?autoplay=false"
      video_id = "153508772"
    end
    return url, video_id
  end
  def unite_video_id
    vimeo_stuff[1]
  end
  def unite_video_url
    vimeo_stuff[0]
  end
  def show_link_to_vote?
    !((controller.controller_name == "votes") && (controller.action_name == "show"))
  end

  def slide_section slide
    result = <<~SECTION
  <li>
    <div class="slider-content">
        <div class="row">
          <div class="col-12 text-center">
            <h1 class="ufs-2 color-white lspacing-medium">
              #{slide[:topic_1]}
            </h1>
            <h5 class="ufs-1 color-white lspacing-medium">
              #{slide[:topic_2]}
            </h5>
            <div class="clear"></div>
            <div class="umt-5">
            #{slide[:link]}
            </div>
          </div>
      </div>
    </div>
    <picture>
      <source media="(max-width: 640px)" srcset="#{slide[:img_mobile]}" />
      <source media="(max-width: 1024px)" srcset="#{slide[:img_tablet]}" />
      <source media="(max-width: 2048px)" srcset="#{slide[:img_screen]}" />
      <img data-src=#{slide[:img_default]} srcset="#{slide[:img_srcset]}" src="#{slide[:img_blank]}" alt="#{slide[:img_alt] || _("Slideshow image")}" />
    </picture>
  </li>
    SECTION
    return result
  end

  ##
  # Fullscreen slider.
  #
  # options - Hash options for the slider (default: {})
  #           :section_classes - Array of additional css classes.
  #           :show_navigation - Boolean to show navigation buttons
  #                              (next, prev).
  #
  # Returns nothing.
  def fs_slider options={}, &block
    options[:section_classes] ||= []
    options[:section_classes] << "unite-screenheight-100"
    raw_slider(options, &block)
  end
  def slider options={}, &block
    options[:section_classes] ||= []
    options[:section_classes] << "unite-screenheight-50"
    raw_slider(options, &block)
  end
  alias :slider_section :slider

  def raw_slider options={}
    section_classes = options[:section_classes] || []
    show_navigation = options[:show_navigation] || false

    slides = yield
    slides_html = []
    slides.map { |option|
      slides_html << slide_section(option)
    }
    slider_navigation_html = show_navigation ? slider_navitation : ""

    result = <<~SECTION
    <section class="slideshow-container unite-slider-container #{section_classes.join(" ")}">
      <ul class="slideshow slideshow-standard" data-decorators="headers,image">
        #{slides_html.join("\n")}
        #{slider_navigation_html}
      </ul>
    </section>
    SECTION
    result.html_safe
  end

  def slider_navitation
    return <<~HTML
      <a href="#" class="slider-nav slider-nav-prev" style="display:none" data-offset="-1">
        <i class="bi bi-chevron-compact-left"></i>
      </a>
      <a href="#" class="slider-nav slider-nav-next" style="display:none" data-offset="1">
        <i class="bi bi-chevron-compact-right"></i>
      </a>
    HTML
  end

  ##
  # public: New slider.
  #
  # slider - Slider
  #
  # Responsive images are created from Slide.res array (which is a list of
  # numbers). Last number is used as min-width for source element. First
  # resolution is used as fallback in img src value.
  #
  # Returns slider html for view.
  def slider_new slider, &block
    return "" unless slider
    return "" if slider.slides.empty?

    additional_html = {}
    if block_given?
      additional_html = yield || {}
      additional_html[:link] = additional_html[:link] || ""
    end

    tag.section class: "slideshow-container slideshow-container-top slideshow-container-#{slider.name} unite-screenheight-100", "data-decorators": slider.decorators.join(", ") do
      slideshow_result = tag.ul class: "slideshow slideshow-#{slider.type}" do
        slider.slides.map do |slide|
          # TODO: slide.decorators.join(",")
          tag.li "data-decorators": slide.decorators.join(", ") do
            li_result = []
            li_result << tag.div(class: "slider-content") do
              content_result = []
              if slide.headers.h1.present?
                content_result << tag.h1(class: "ufs-1-5 color-white lspacing-medium") do
                  slide.headers.h1.join(" ")
                end
              end
              if slide.headers.h2.present?
                content_result << tag.h2(class: "ufs-1 color-white lspacing-medium") do
                  slide.headers.h2.join(" ")
                end
              end
              if additional_html[:link].present?
                content_result << tag.div(class: "upt-10") do
                  additional_html[:link]
                end
              end
              content_result.join.html_safe
            end
            li_result << tag.picture do
              # slide.res = 640
              # slide.img_type = 'jpg'
              # =>
              # <source media="(max-width: 640px)" srcset="#{slide.name}-w#{res}.img_type" />
              source = slide.res.map do |r|
                tag.source(media: "(max-width: #{r}px)", srcset:"#{slide_image_path(slide, r)}")
              end
              source << tag.source(media: "(min-width: #{slide.res[-1]}px)", srcset:"#{slide_image_path(slide, slide.res[-1])}")
              source << image_tag(slide_image_path(slide, slide.default), "alt" => slide.alt)
              source.join.html_safe
            end
            li_result.join.html_safe
          end
        end.join.html_safe
      end
      slideshow_result << tag.div(class: "slideshow-headers umx-5 text-center") do
        headers_result = []
        # TODO: if h1 then ...
        if slider.headers.h1.present?
          headers_result << tag.h1 do
            slider.headers.h1.join(" ")
          end
        end
        if slider.headers.h2.present?
          headers_result << tag.h2 do
            slider.headers.h2.join(", ")
          end
        end
        if slider.headers.h3.present?
          headers_result <<  tag.h3 do
            slider.headers.h3.join(", ")
          end
        end
        headers_result.join.html_safe
      end
    end
  end

  ## public: Get image path.
  #
  # slide - Slide
  # res   - number i.e. 640
  #
  # Returns image path.
  def slide_image_path slide, res
    image_path("slides/#{slide.name}-w#{res}.#{slide.type}")
  end


  def campaign_assistant
    result = <<~HTML
    <p>
      #{_("Contact our Campaign Assistant")}:<br>
      <a class="button small" style="color:#333 !important" href="mailto:#{UNITE_CAMPAIGN_ASSISTANT_EMAIL}">#{UNITE_CAMPAIGN_ASSISTANT_EMAIL}</a>
    </p>
    HTML
    result.html_safe
  end

  def copyright
    "&copy; 2015-#{Time.now.year} SAVE THE PLANET - UNITE THE ARMIES. All Rights Reserved.".html_safe
  end

  def language_item identifier
    ui_locale = FastGettext.locale

    case identifier
    when :arabic
      loc = :ar
      FastGettext.locale = loc
      name = _("in Arabic")
    when :chinese
      loc = :zh
      FastGettext.locale = loc
      name = _("in Chinese")
    when :french
      loc = :fr
      FastGettext.locale = loc
      name = _("in French")
    when :russian
      loc = :ru
      FastGettext.locale = loc
      name = _("in Russian")
    when :spanish
      loc = :es
      FastGettext.locale = loc
      name = _("in Spanish")
    when :finnish
      loc = :fi
      FastGettext.locale = loc
      name = _("in Finnish")
    when :german
      loc = :de
      FastGettext.locale = loc
      name = _("in German")
    when :swedish
      loc = :sv
      FastGettext.locale = loc
      name = _("in Swedish")
    else
      loc = :en
      FastGettext.locale = loc
      name = _("in English")
    end

    FastGettext.locale = ui_locale

    tag.li class: "select-language" do
      tag.a target: "_top", href: url_for(only_path: false, locale: loc, protocol: UNITE_APPLICATION_PROTOCOL) do
        name
      end
    end
# <li>
#   <a target="_top" href="#{url_for only_path: false, locale: :ar, protocol: UNITE_APPLICATION_PROTOCOL}" onclick="window.location = $(this).attr('href')">
#   </a>
# </li>
  end

  def language_selection
    result = tag.ul class: "language-selection" do
      Language::UI.identifiers.map do |identifier|
        language_item identifier
      end.join.html_safe
    end
    result
  end

  ## Random comments
  #
  # @param [string] language as an identifier i.e. finnish
  def random_comment
    language = Language::UI.identifier locale
    unless language
      logger.error("ApplicationHelper#random_comment: Language not found! locale:#{locale}")
      return
    end

    comment = Comment.random_comment_for_language language
    return unless comment.present?
    tag.div class: "container-fluid random-comment" do
      result = []
      result << tag.div(class: "random-comment-body") do
        tag.i do
          comment.body
        end
      end
      result << tag.div(class: "random-comment-name") do
        comment.name
      end
      result.join("\n").html_safe
    end
  end

end
