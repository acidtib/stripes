class UsersController < ApplicationController
  
  def show id = params[:id]
    user_data = Instagram.get_user_info id
    user_feed_data = Instagram.get_user_feed id
    @user = user_data["data"]
    @photos = user_feed_data["data"]
  end
  
end
