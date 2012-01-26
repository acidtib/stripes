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
  
  rescue_from BadRequestError, :with => :bad_request_page
  rescue_from NotFoundError, :with => :page_not_found_page
  rescue_from InternalServerError, :with => :instagram_is_broken_page
  rescue_from ServiceUnavailableError, :with => :instagram_is_down_page
  
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end
  
  def get_session_data
    if session.key? :access_token
      @session = session[:access_token]
      @access_token = @session["access_token"]
      @current_user = Meta::User.new @session["user"]
      IGNetworking::Request.init @access_token
    end
  end
  
  def logged_in
    @session
  end

  def check_authorization
    unless logged_in
      session[:redirect] = request.url
      render :layout => "splash", :file => "home/unauthorized"
    end
  end

  def redirect_to_instagram_auth
    redirect_to IGNetworking::OAuth.request_auth_url
  end

  def get_instagram_access_and_redirect code
    response = IGNetworking::OAuth.authorize code
    session[:access_token] = JSON.parse response

    if session[:redirect]
      url = session[:redirect]
      session[:redirect] = nil
      redirect_to url
    else
      redirect_to :controller => :home, :action => :feed
    end
  end

  # authentication etc

  def login
    redirect_to_instagram_auth
  end

  def auth
    code = params[:code]
    get_instagram_access_and_redirect code
  end

  def logout
    session[:access_token] = nil
    IGNetworking::Request.halt
    redirect_to :controller => :home, :action => :index
  end

  # error pages
  
  def bad_request_page
    render :status => 400
  end
  
  def page_not_found_page
    render :layout => nil, :file => "#{Rails.root}/public/404.html", :status => 404
  end
  
  def instagram_is_broken_page
    render  :layout => nil, :file => "#{Rails.root}/public/500.html", :status => 500
  end
  
  def instagram_is_down_page
    render :status => 503
  end
  
end
