class HomeController < ApplicationController

  before_filter :check_authorization, :except => [ :index ]

  def index
    if logged_in
      redirect_to :action => :feed
    else
      render :layout => "splash"
    end
  end
  
  def feed
    @photos, @next_page_max_id = Instagram.get_my_recent_media
  end

  def popular
    @photos = Instagram.get_popular_media
  end
  
  def feed_page_from_max_id
    @photos, @next_page_max_id = Instagram.get_my_recent_media params[:max_id]
    render :text => JSON.generate( 
      { 
        :next_max_id => @next_page_max_id, 
        :html => render_to_string(:partial => "shared/feed_item", 
                                  :collection => @photos, :as => :p)
      } 
    )
  end
    
end
