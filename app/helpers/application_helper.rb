module ApplicationHelper
  BOOTSTRAP_FLASH_MSG = {
    primary: "alert-primary",
    secondary: "alert-secondary",
    success: "alert-success",
    danger: "alert-danger",
    warning: "alert-warning",
    info: "alert-info",
    light: "alert-light",
    dark: "alert-dark"
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type, flash_type.to_s)
  end

  def flash_messages
    # flash[:success] = _("Thank you for your vote!")
    flash.map do |name, msg|
      flash_classes = [ "alert alert-dismissable fade show", bootstrap_class_for(name.to_sym) ]
      content_tag(:div, class: flash_classes, role: "alert", onClick: "$(this).hide()") do
        content_tag(:h2, class: "h2 alert-heading") do msg end
      end
    end.join.html_safe
  end

  ## Link to Token
  #
  def link_to_token
    link_to new_token_url do
      # tag.i class: "bi bi-flower1", title: _("To your private vote")
      _("My vote")
    end
  end

  def link_to_vote
    vote_id = session[:current_vote_id]
    unless vote_id
     return link_to_token
    end
    vote = Vote.find_by_id(vote_id)
    unless vote
     return link_to_token
    end

    token = vote.encoded_payload
    link_to vote_url(token: token) do
      # tag.i class: "bi bi-chat-square", title: _("Your private vote")
      _("My vote")
    end
  end

  def link_to_logout
    link_to logout_url, method: :delete do
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
      <div class="container tms-content-inner center left-on-mobile v-align-middle">
        <div class="row">
          <div class="col-12 text-center">
            <h1 class="fw-bold fs-10 position-static color-white tms-caption lspacing-medium mb-20 weight-bold" data-animate-in="opacity:0;scale:1.5px;duration:600ms;easing:easeFastSlow;" data-no-scale>
              #{slide[:topic_1]}
            </h1>
            <div class="clear"></div>

            <h5 class="fw-bold fs-5 position-static tms-caption color-white lspacing-medium hide-on-mobile" data-animate-in="opacity:0;transY:50px;duration:600ms;delay:300ms;easing:easeFastSlow;" data-no-scale>
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

end
