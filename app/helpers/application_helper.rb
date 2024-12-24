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
      content_tag(:div, class: flash_classes, role: "alert", onclick: "unite.closeFlash()") do
        content_tag(:h2, class: "h2 alert-heading") do msg end
      end
    end.join.html_safe
  end

  ## Link to Token
  #
  def link_to_token
    link_to new_token_url do
      tag.i class: "bi bi-flower1", title: _("To your private vote")
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
      tag.i class: "bi bi-chat-square", title: _("Your private vote")
    end
  end

  def link_to_logout
    link_to logout_url, method: :delete do
      tag.i class: "bi bi-box-arrow-right", title: _("Logout")
    end
  end

  def button_white
    skin_barber_shop_removed = "button tms-caption thick "
    skin_barder_shop_stays = "bkg-cornflowerblue bkg-hover-white color-black color-hover-black text-uppercase "
    # bootstrap = "py-4 px-6 fw-bold fs-3 position-static text-decoration-none shadow rounded border border-light opacity-100"
    bootstrap = "py-4-5 px-6 fs-4 position-static opacity-100 shadow border border-2 border-light rounded"
    skin_barder_shop_stays + bootstrap
  end

  def button_test
    "button tms-caption thick bkg-black bkg-hover-cornflowerblue color-white color-hover-white text-uppercase py-4-5 px-6 fs-4 position-static opacity-100 shadow border border-2 border-light rounded"
  end

  def button_black
    skin_barber_shop_removed = "button tms-caption thick "
    skin_barder_shop_stays = "bkg-cornflowerblue bkg-hover-black color-white color-hover-white text-uppercase "
    bootstrap = "py-4-5 px-6 fs-4 position-static opacity-100 shadow border border-2 border-light rounded"
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
end
