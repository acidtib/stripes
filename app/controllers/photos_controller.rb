class PhotosController < ApplicationController
  
  def show id=params[:id]
    data = wrap_request "media/#{id}"
    likes_data = wrap_request "media/#{id}/likes"
    comments_data = wrap_request "media/#{id}/comments"
    @photo = data["data"]
    @likes = likes_data["data"]
    @comments = comments_data["data"]
  end
  
  def index
    redirect_to :controller => :home, :action => :feed
  end
  
end
