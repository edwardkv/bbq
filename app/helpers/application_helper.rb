module ApplicationHelper

  def user_avatar(user)
    asset_pack_path('media/images/user.png')
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def bootstrap_flash(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert") do
        concat content_tag(:button, '×', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  private
  def bootstrap_class_for(level)
    case level
    when "notice" then "alert-info"
    when "success" then "alert-success"
    when "error" then "alert-warning"
    when "alert" then "alert-danger"
    else level
    end
  end

end
