class HomeController < ApplicationController

  before_filter :check_authorization, :except => [ :index ]
  after_filter :cache_data, :except => [ :index ]

  def cache_data
    User.cache_data @photos if @photos
  end

  def index
    if logged_in?
      redirect_to :action => :feed
    else
      request.user_agent.include?("iPhone") ? render(:layout => "iphone_splash") : render(:layout => "splash")
    end
  end

  def feed
    @photos, @next_page_max_id = Instagram.get_my_feed @access_token
  end

  def popular
    @photos = Instagram.get_popular_media @access_token
  end

  def feed_page_from_max_id
    photos, next_page_max_id = Instagram.get_my_feed_from_max_id @access_token, params[:max_id]
    render :json => { :next_max_id => next_page_max_id, :html => render_to_string(:partial => "shared/feed_item", :collection => photos, :as => :p) }
  end
end
