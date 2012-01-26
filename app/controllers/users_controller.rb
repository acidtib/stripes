class UsersController < ApplicationController

  before_filter :check_authorization
  
  def show
    cache = User.find_by_username(params[:username])
    cache = User.find_by_instagram_id(params[:username].to_i) if params[:username].to_i > 0 and not cache
    
    unless cache
      users = Instagram.search_users params[:username]
      cache = users.first if users
    end

    user_id = 0

    if cache.kind_of? Meta::User
      user_id = cache.id
    elsif cache.kind_of? User
      user_id = cache.instagram_id
    else
      user_id = params[:username]
    end
      
    @user = Instagram.get_user_info user_id
    @photos, @next_page_max_id = Instagram.get_user_feed user_id

    User.cache_data @user
  end
  
  def feed_page_from_max_id
    @photos, @next_page_max_id = Instagram.get_user_feed params[:id], params[:max_id]
    render :text => JSON.generate( { :next_max_id => @next_page_max_id, 
      :html => render_to_string(:partial => "shared/feed_item", :collection => @photos, :as => :p)
    } )
  end

  def bad_request_page
    render :layout => nil, :file => "#{Rails.root}/public/404.html", :status => 404
  end

end