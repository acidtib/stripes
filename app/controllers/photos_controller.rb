class PhotosController < ApplicationController

  before_filter :check_authorization
  
  def show
    @photo = Instagram.get_media_data params[:id]
    @likes_users = Instagram.get_media_likes params[:id]
    @comments = Instagram.get_media_comments params[:id]
  end
  
  def index
    redirect_to :controller => :home, :action => :feed
  end
  
  def like
    render :json => Instagram.like_media(params[:id])
  end
  
  def unlike
    render :json => Instagram.unlike_media(params[:id])
  end
  
  # fix to obscure instagram errors about bad requests when you
  # provide wrong or illegal media id
  def bad_request_page
    render :layout => nil, :file => "#{Rails.root}/public/404.html", :status => 404
  end
  
end
