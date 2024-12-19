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

  def link_to_token
    link_to new_token_url do
      tag :span, class: "icon-flower medium", title: _("Get to your private vote")
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
      tag :span, class: "icon-heart medium", title: _("Your private vote")
    end
  end

  def link_to_logout
    link_to logout_url, method: :delete do
      tag :span, class: "icon-bell medium", title: _("Logout")
    end
  end
end
