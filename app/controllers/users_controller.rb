class UsersController < ApplicationController
  
  def show id = params[:id]
    user_data = wrap_request("/users/#{id}")
    user_feed_data = wrap_request("/users/#{id}/media/recent")
    @user = user_data["data"]
    @photos = user_feed_data["data"]
  end
  
end
