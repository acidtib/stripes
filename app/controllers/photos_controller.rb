class PhotosController < ApplicationController
  
  def show id=params[:id]
    data = Instagram.get_media_data id
    likes_data = Instagram.get_media_likes id
    comments_data = Instagram.get_media_comments id
    @photo = data["data"]
    @likes = likes_data["data"]
    @comments = comments_data["data"]
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
  
end
