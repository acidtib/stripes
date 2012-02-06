class UsersController < ApplicationController

  before_filter :check_authorization
  
  def show # TODO: REFACTOR THIS SHIT
    cache = User.find_by_username(params[:username])
    cache = User.find_by_instagram_id(params[:username].to_i) if params[:username].to_i > 0 and not cache

    unless cache
      users = Instagram.search_users @access_token, params[:username]
      cache = users.first if users
    end

    user_id = 0

    if cache.kind_of? Instagram::User
      user_id = cache.id
    elsif cache.kind_of? User
      user_id = cache.instagram_id
    else
      user_id = params[:username]
    end
      
    @user = Instagram.get_user_info @access_token, user_id
    @relation = Instagram.get_user_relationship @access_token, user_id
    @photos, @next_page_max_id = Instagram.get_user_feed @access_token, user_id

    User.cache_data @user
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
