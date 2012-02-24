class ApplicationController < ActionController::Base
  protect_from_forgery

  require "yajl"
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
      @current_user = Instagram::AuthorizedUser.new Yajl::Parser.parse(session[:user], { :symbolize_keys => true }), ''
      @access_token = Yajl::Parser.parse(session[:user])["access_token"]
    end
  end

  def logged_in?
    @current_user
  end

  def check_authorization
    unless logged_in?
      session[:redirect] = request.url
      render :layout => "splash", :action => "unauthorized"
    end
  end

  def get_instagram_access_and_redirect code # REFACTOR!!!
    if (user = Instagram.authorize_and_get_user code)
      @current_user = user
      session[:user] = user.to_json
      UsersCache.cache_data @current_user if User.create_from_meta @current_user

      if session[:redirect] # how to handle this shit?
        url = session[:redirect]
        session[:redirect] = nil
        redirect_to url
      else
        redirect_to :controller => :home, :action => :feed
      end
    else
      # TODO: handle errors during authorization
      redirect_to :controller => :home, :action => :index
    end
  end

  # authentication routing

  def login
    redirect_to Instagram.authentication_url
  end

  def auth
    get_instagram_access_and_redirect params[:code]
  end

  def logout
    session[:user] = @current_user = @access_token = nil
    redirect_to :controller => :home, :action => :index
  end

  # some common shit

  def search_user_everywhere username
    unless (cache = UsersCache.find_by_username_or_id username)
      cache ||= Instagram.search_users(@access_token, username).first
    end

    user_id = cache.respond_to?(:instagram_id) ? cache.instagram_id : username.to_i
  end
end
