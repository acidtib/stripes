class Instagram
  
  def self.get_my_recent_media
    JSON.parse IGNetworking::Request.get("users/self/feed", :count => 40).body
  end
  
  def self.get_user_info user_id
    JSON.parse IGNetworking::Request.get("/users/#{user_id}").body
  end
  
  def self.get_user_feed user_id
    JSON.parse IGNetworking::Request.get("/users/#{user_id}/media/recent").body
  end
  
  def self.get_media_data media_id
    JSON.parse IGNetworking::Request.get("media/#{media_id}").body
  end
  
  def self.get_media_likes media_id
    JSON.parse IGNetworking::Request.get("media/#{media_id}/likes").body
  end
  
  def self.get_media_comments media_id
    JSON.parse IGNetworking::Request.get("media/#{media_id}/comments").body
  end
  
  def self.like_media media_id
    IGNetworking::Request.post("media/#{media_id}/likes/").body
  end
  
  def self.unlike_media media_id
    IGNetworking::Request.delete("media/#{media_id}/likes/").body
  end
  
end
