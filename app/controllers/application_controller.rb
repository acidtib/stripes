# some custom error definitions
class Error404 < StandardError; end
class MediaNotFoundError < Error404; end

# there goes
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require 'i_g_networking'
  
  before_filter :get_session_data
  
  rescue_from MediaNotFoundError, :with => :generic_error_page
  
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
  
  def generic_error_page e
    render :text => e.message
  end
  
end
