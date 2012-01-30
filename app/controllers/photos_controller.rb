class PhotosController < ApplicationController

  before_filter :check_authorization
  
  def show
    @photo = Instagram.get_media params[:id]
    
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
    data = Instagram.like_media params[:id]
    photo = Instagram.get_media params[:id]
    html_update = view_context.pluralize photo.likes_count, "like", "likes"
    render :json => data.chop.concat(",\"html\": \"#{html_update}\"}")
  end
  
  def unlike
    data = Instagram.unlike_media params[:id]
    photo = Instagram.get_media params[:id]
    html_update = view_context.pluralize photo.likes_count, "like", "likes"
    render :json => data.chop.concat(",\"html\": \"#{html_update}\"}")
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

  def comment
    data = Instagram.post_comment params[:id], params[:text]
    if data["meta"]["code"] == 200
      comment = Meta::Comment.new data["data"]
      comment.user = @current_user
      data["html"] = render_to_string(:partial => "photos/comment", :locals => { :comment => comment })
      render :json => data
    else
      render :json => data
    end
  end
  
end
