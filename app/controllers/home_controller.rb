class HomeController < ApplicationController
  
#  before_filter :update_current_user_likes 
  
  def index
    unless logged_in
      redirect_to_instagram_auth 
    else
      render :text => @session["access_token"]
    end
  end
  
  def auth
    code = params[:code]
    get_instagram_access_and_redirect code
  end
  
  def feed
    media = wrap_request("users/self/feed", "count=40")
    
    if media["data"]
      @photos = media["data"]
    else
      render :text => "fuck, what has just happened?"
    end
    
  end
  
  def logout
    session[:access_token] = nil
    redirect_to :action => :index
  end
  
  def temp
    data = wrap_request("/users/search", "q=vocaltsunami&count=1")
    render :text => data
  end
  
end
