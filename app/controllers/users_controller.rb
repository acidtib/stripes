class UsersController < ApplicationController
  
  def show id = params[:id]
    @user = Instagram.get_user_info id
    @photos, @next_page_max_id = Instagram.get_user_feed id
  end
  
  def feed_page_from_max_id
    @photos, @next_page_max_id = Instagram.get_user_feed params[:id], params[:max_id]
    render :text => JSON.generate( { :next_max_id => @next_page_max_id, 
      :html => render_to_string(:partial => "shared/feed_item", :collection => @photos, :as => :p)
    } )
  end
  
end
