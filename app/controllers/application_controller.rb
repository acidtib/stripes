class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require 'i_g_networking'
  
  before_filter :get_session_data
  
  # just preloading session object  
  def get_session_data
    if session[:access_token]
      @session = session[:access_token]
      @access_token = @session["access_token"]
      IGNetworking::Request.init @access_token
      @current_user = User.find_or_create_by_instagram_id_and_username(@session["user"]["id"].to_i, @session["user"]["username"])
    end
  end
  
  # simple check if someone has already logged in with instagram
  def logged_in
    session[:access_token]
  end

  # clumsy handling instagram authentification
  def redirect_to_instagram_auth
    redirect_to "https://api.instagram.com/oauth/authorize/?client_id=5b94ab73a59145be939858ad04be772d&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth&response_type=code&scope=basic+comments+relationships+likes"
  end

  def get_instagram_access_and_redirect code
    
    http = Net::HTTP.new 'api.instagram.com', 443
    http.use_ssl = true
    path = '/oauth/access_token'
    
    response = http.post(path, "client_id=5b94ab73a59145be939858ad04be772d&client_secret=800e0c7c46c243a48ece23d022ce25d0&grant_type=authorization_code&code=#{code}&redirect_uri=#{CGI::escape('http://localhost:3000/auth')}")
    
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      session[:access_token] = JSON.parse response.body
      @session = session[:access_token]
      redirect_to :controller => :home, :action => :feed
    else
      response.error!
    end
  end
  
end
