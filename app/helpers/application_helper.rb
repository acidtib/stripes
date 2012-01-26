module ApplicationHelper
  
  def is_current? controller, action
    "current" if @current_controller == controller and @current_action == action
  end

  def parse_usernames message
    message.gsub /@([\w\d]*)/ do |match|
      "<span class=\"user\">#{match}</span>"
    end
  end
  
end
