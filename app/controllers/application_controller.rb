class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require "instagram"
  
  before_filter :get_session_data, :except => [ :login, :logout ]
  before_filter :instantiate_controller_and_action_names
  caches_action :instantiate_controller_and_action_names
  
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end
  
  def get_session_data
    if session.key? :user
      @current_user = Instagram::AuthorizedUser.new JSON.parse(session[:user], { :symbolize_names => true }), ''
      @access_token = JSON.parse(session[:user])["access_token"]
    end
  end
  
  def logged_in?
    @current_user
  end

  def check_authorization
    unless logged_in?
      session[:redirect] = request.url
      render :layout => "splash", :file => "home/unauthorized"
    end
  end

  def redirect_to_instagram_auth
    redirect_to Instagram.authentication_url
  end

  def get_instagram_access_and_redirect code
    user = Instagram.authorize code

    if user
      @current_user = user
      session[:user] = user.to_json
      
      if session[:redirect] # how to handle this shit?
        url = session[:redirect]
        session[:redirect] = nil
        redirect_to url
      else
        redirect_to :controller => :home, :action => :feed
      end
    else
      flash[:notice] = "Something went wrong."
      redirect_to :controller => :home, :action => :index
    end
  end

  # authentication routing

  def login
    redirect_to_instagram_auth
  end

  def auth
    code = params[:code]
    get_instagram_access_and_redirect code
  end

  def logout
    session[:user] = nil
    @current_user = nil
    redirect_to :controller => :home, :action => :index
  end

end
