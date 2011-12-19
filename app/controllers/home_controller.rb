class HomeController < ApplicationController 
  
  def index
    if logged_in
      redirect_to :action => :feed
    else
      render :layout => "splash"
    end
  end
  
  def login
    redirect_to_instagram_auth
  end
  
  def auth
    code = params[:code]
    get_instagram_access_and_redirect code
  end
  
  def feed
    media = Instagram.get_my_recent_media
    
    if media["data"]
      @photos = media["data"]
    else
      render :text => "Media data = nil, omg wtf."
    end
  end
  
  def logout
    session[:access_token] = nil
    IGNetworking::Request.halt
    redirect_to :action => :index
  end
  
  def temp
    data = wrap_request("/users/search", "q=vocaltsunami&count=1")
    render :text => data
  end
  
end
