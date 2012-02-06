class PhotosController < ApplicationController

  before_filter :check_authorization
  
  def show
    @photo = Instagram.get_media @current_user.access_token, params[:id]
    
    if @photo.likes_count < 250
      @likes_users = Instagram.get_media_likes @current_user.access_token, params[:id]
      User.cache_data @likes_users
    else
      @lazy_load_likes = true
    end

    if @photo.comments_count < 50
      @comments = Instagram.get_media_comments @current_user.access_token, params[:id]
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
    response = Instagram.like_media @current_user.access_token, params[:id]
    if response.ok? and (photo = Instagram.get_media @current_user.access_token, params[:id])
      response[:html] = view_context.pluralize photo.likes_count, "like", "likes"
    end
    render :json => response
  end
  
  def unlike
    response = Instagram.unlike_media @current_user.access_token, params[:id]
    if response.ok? and (photo = Instagram.get_media @current_user.access_token, params[:id])
      response[:html] = view_context.pluralize photo.likes_count, "like", "likes"
    end
    render :json => response
  end

  # xhr methods for lazy loading 
  def lazy_load_likes
    likes_users = Instagram.get_media_likes @current_user.access_token, params[:id]
    render :text => JSON.generate( { :html => render_to_string(:partial => "like", :collection => likes_users, :as => :user) } )
  end

  def lazy_load_comments
    comments = Instagram.get_media_comments @current_user.access_token, params[:id]
    render :text => JSON.generate( { :html => render_to_string(:partial => "comment", :collection => comments) } )    
  end
  
  def comment
    response, comment = Instagram.comment_on_media @current_user.access_token, params[:id], params[:text]
    if response.ok? and comment
      comment.from = @current_user
      response[:html] = render_to_string(:partial => "photos/comment", :locals => { :comment => comment })

      photo = Instagram.get_media @current_user.access_token, params[:id]
      counter_update = view_context.pluralize photo.comments_count, "comment"
      response[:counter_update] = "<span>Back</span>" + counter_update
    end
    render :json => response
  end
  
end
