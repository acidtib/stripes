class PhotosController < ApplicationController
  
  def show id=params[:id]
    @photo = Instagram.get_media_data id
    @likes_users = Instagram.get_media_likes id
    @comments = Instagram.get_media_comments id
  end
  
  def index
    redirect_to :controller => :home, :action => :feed
  end
  
  def comment id=params[:id]
    
  end
  
  def like id=params[:id]
    render :json => Instagram.like_media(id)
  end
  
  def unlike id=params[:id]
    render :json => Instagram.unlike_media(id)
  end
  
  # fix to obscure instagram errors about bad requests when you
  # provide wrong or illegal media id
  def bad_request_page
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end
  
end
