class HomeController < ApplicationController 
  
  def index
    if logged_in
      redirect_to :action => :feed
    else
      render :layout => "splash"
    end
  end
  
  def login
    redirect_to_instagram_auth
  end

  def auth
    code = params[:code]
    get_instagram_access_and_redirect code
  end
  
  def feed
    @photos, @next_page_max_id = Instagram.get_my_recent_media
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
  
  def popular
    @photos = Instagram.get_popular_media
  end
    
end
