class PhotosController < ApplicationController

  before_filter :check_authorization
  
  def show
    @photo = Instagram.get_media_data params[:id]
    
    if @photo.likes_count < 250
      @likes_users = Instagram.get_media_likes params[:id]
      User.cache_data @likes_users
    else
      @lazy_load_likes = true
    end

    if @photo.comments_count < 50
      @comments = Instagram.get_media_comments params[:id]
      User.cache_data @comments
    else
      @lazy_load_comments = true
    end

    User.cache_data @photo
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

  # xhr methods for lazy loading 
  def lazy_load_likes
    likes_users = Instagram.get_media_likes params[:id]
    render :text => JSON.generate( { :html => render_to_string(:partial => "like", :collection => likes_users, :as => :user) } )
  end

  def lazy_load_comments
    comments = Instagram.get_media_comments params[:id]
    render :text => JSON.generate( { :html => render_to_string(:partial => "comment", :collection => comments) } )    
  end
  
  # fix to obscure instagram errors about bad requests when you
  # provide wrong or illegal media id
  def bad_request_page
    render :layout => nil, :file => "#{Rails.root}/public/404.html", :status => 404
  end
  
end
