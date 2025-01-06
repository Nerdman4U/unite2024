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

  def button_white
    # skin_barber_shop_removed = "button tms-caption thick "
    skin_barder_shop_stays = "bkg-white bkg-hover-black color-black color-hover-white text-uppercase "
    bootstrap = "upy-2 upx-3 ufs-2 position-static opacity-100 shadow border border-2 border-light rounded"
    skin_barder_shop_stays + bootstrap
  end

  def button_black
    # skin_barber_shop_removed = "button tms-caption thick "
    skin_barder_shop_stays = "bkg-black bkg-hover-white color-white color-hover-black text-uppercase "
    bootstrap = "upy-2 upx-3 ufs-2 position-static opacity-100 shadow border border-2 border-light rounded"
    skin_barder_shop_stays + bootstrap
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
  <li class="tms-slide" data-image data-force-fit>
    <div class="tms-content">
      <div class="tms-content-inner center left-on-mobile v-align-middle">
        <div class="row">
          <div class="col-12 text-center">
            <h1 class="ufs-2 position-static color-white tms-caption lspacing-medium" data-animate-in="opacity:0;scale:1.5px;duration:600ms;easing:easeFastSlow;" data-no-scale>
              #{slide[:topic_1]}
            </h1>
            <div class="clear"></div>
            <h5 class="ufs-1 position-static tms-caption color-white lspacing-medium hide-on-mobile" data-animate-in="opacity:0;transY:50px;duration:600ms;delay:300ms;easing:easeFastSlow;" data-no-scale>
              #{slide[:topic_2]}
            </h5>
            <div class="clear"></div>
            #{slide[:link]}
          </div>
        </div>
      </div>
    </div>
    <img data-src=#{slide[:img]} data-retina src=#{slide[:img_blank]} alt="#{slide[:img_alt] || _("Slideshow image")}" />
  </li>
    SECTION

    return result
  end

  ## Full screen slider
  def fs_slider section_classes=[], &block
    # raw_slider(["window-height"], &block)
    raw_slider(section_classes + ["unite-screenheight-100"], &block)
  end
  def slider &block
    raw_slider(&block)
  end
  alias :slider_section :slider
  def raw_slider section_classes=[]
    slides = yield

    slide_html = []
    slides.map { |option|
      slide_html << slide_section(option)
    }

    slides_str = slide_html.join
    # full-width-slider
    result = <<~SECTION
    <section class="unite-slider-container section-block featured-media tm-slider-parallax-container unite-screenheight-50 #{section_classes.join(" ")}" onclick="window.unite.toggleSliderHeight();">
  <div class="tm-slider-container full-width-slider" data-featured-slider data-progress-bar="false" data-parallax data-parallax-fade-out data-auto-advance data-animation="slide" data-scale-under="960">
    <ul class="tms-slides">
      #{slides_str}
    </ul>
  </div>
</section>
    SECTION

    result.html_safe
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

end
