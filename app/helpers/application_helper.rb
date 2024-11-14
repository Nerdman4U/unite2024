module ApplicationHelper

  BOOTSTRAP_FLASH_MSG = {
    success: 'alert-success',
    error: 'alert-error',
    alert: 'alert-block',
    notice: 'alert-info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type, flash_type.to_s)
  end

  def flash_messages
    flash.map do |name, msg|
      flash_classes = ["alert", "alert-dismissable", bootstrap_class_for(name.to_sym)]
      content_tag(:div, class: flash_classes) do
        html = button_tag(type: :button, class: :close, :"data-dismiss" => "alert") do
          "&times;".html_safe
        end
        html << ("<h2>"+msg+"</h2>").html_safe
        html
      end
    end.join.html_safe
  end

end
