class UsersController < ApplicationController

  before_filter :check_authorization

  def show
    user_id = search_user_everywhere params[:username]
    if (@user = Instagram.get_user_info @access_token, user_id)
      @relation = Instagram.get_user_relationship @access_token, user_id
      @photos, @next_page_max_id = Instagram.get_user_feed @access_token, user_id
      UsersCache.cache_data @user
    else
      render :file => "#{Rails.root}/public/404.html"
    end
  end

  def feed_page_from_max_id
    @photos, @next_page_max_id = Instagram.get_user_feed_from_max_id @access_token, params[:id], params[:max_id]
    render :json => { :next_max_id => @next_page_max_id, :html => render_to_string(:partial => "shared/feed_item", :collection => @photos, :as => :p) }
  end

  def follow
    response = Instagram.follow_user @access_token, params[:id]
    user = Instagram.get_user_info @access_token, params[:id]
    response[:html] = view_context.meta_pluralize user.followers, "follower"
    render :json => response
  end

  def unfollow
    response = Instagram.unfollow_user @access_token, params[:id]
    user = Instagram.get_user_info @access_token, params[:id]
    response[:html] = view_context.meta_pluralize user.followers, "follower"
    render :json => response
  end

end
