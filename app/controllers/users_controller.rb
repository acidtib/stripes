class UsersController < ApplicationController

  before_filter :check_authorization
  
  def show
    @user = Instagram.get_user_info params[:id]
    @photos, @next_page_max_id = Instagram.get_user_feed params[:id]

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