module ApplicationHelper
  BOOTSTRAP_FLASH_MSG = {
    success: "alert-success",
    error: "alert-error",
    alert: "alert-block",
    notice: "alert-info"
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type, flash_type.to_s)
  end

  def flash_messages
    flash[:success] = _("Thank you for your vote!")
    flash.map do |name, msg|
      flash_classes = [ "alert alert-dismissable fade show", bootstrap_class_for(name.to_sym) ]
      content_tag(:div, class: flash_classes, role: "alert", onclick: "unite.closeFlash()") do
        content_tag(:h2, class: "h2 alert-heading") do msg end
      end
    end.join.html_safe
  end
end
