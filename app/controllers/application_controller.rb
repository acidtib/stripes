class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require "uri"
  require "net/http"
  require "net/https"
  require "json"

  before_filter :get_session_data
  
  # just preloading session object  
  def get_session_data
    if session[:access_token]
      @session = session[:access_token]
      @access_token = @session["access_token"]
      @current_user = User.find_or_create_by_instagram_id_and_username(@session["user"]["id"].to_i, @session["user"]["username"])
    end
  end
  
  def update_current_user_likes
    media = wrap_request "users/self/media/liked"
    media["data"].each do |p|
      @current_user.likes.find_or_create_by_media_id p["id"].to_i
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
    params = {
      :client_id => '5b94ab73a59145be939858ad04be772d',
      :client_secret => '800e0c7c46c243a48ece23d022ce25d0',
      :grant_type => 'authorization_code',
      :redirect_uri => CGI::escape('http://localhost:3000/auth'),
      :code => code
    }
    
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
  
  # instagram request wrapper
  def wrap_request request, params = nil
    http = Net::HTTP.new 'api.instagram.com', 443
    http.use_ssl = true
    path = "/v1/#{request}"
    
#    render :text => "#{path}?access_token=#{@access_token}"
    
    params = "&#{params}" if params
    
    response = http.get("#{path}?access_token=#{@access_token}#{params}")
    return JSON.parse(response.body)
  end
  
end
