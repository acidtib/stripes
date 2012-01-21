module ApplicationHelper
  
  def is_current? controller, action
    "current" if @current_controller == controller and @current_action == action
  end
  
end
