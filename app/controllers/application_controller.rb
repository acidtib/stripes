# some custom error definitions
class MetaError < StandardError; end
class BadRequestError < MetaError; end
class InternalServerError < MetaError; end
class NotFoundError < MetaError; end
class ServiceUnavailableError < MetaError; end


# there goes
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require 'i_g_networking'
  
  before_filter :get_session_data
  before_filter :instantiate_controller_and_action_names
  caches_action :instantiate_controller_and_action_names
  
  rescue_from BadRequestError, :with => :relogin_error_page
  rescue_from NotFoundError, :with => :page_not_found_page
  rescue_from InternalServerError, :with => :instagram_is_broken_page
  rescue_from ServiceUnavailableError, :with => :instagram_is_down_page
  
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end
  
  def get_session_data
    if session[:access_token]
      @session = session[:access_token]
      @access_token = @session["access_token"]
      IGNetworking::Request.init @access_token
    end
  end
  
  def logged_in
    session[:access_token]
  end

  def redirect_to_instagram_auth
    redirect_to IGNetworking::OAuth.request_auth_url
  end

  def get_instagram_access_and_redirect code
    response = IGNetworking::OAuth.authorize code
    session[:access_token] = JSON.parse response
    @session = session[:access_token]
    redirect_to :controller => :home, :action => :feed
  end
  
  def instagram_is_broken_page
    
  end
  
  def page_not_found_page
    render :layout => "error_layout", :partial => "shared/generic_error", :locals => { :message => "Some shit just has happened, you know" }
  end
  
  def relogin_error_page
    
  end
  
  def instagram_is_down_page
  end
  
end
