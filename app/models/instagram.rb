class Instagram
  
  def self.handle response, args = {}
    unless response.code == "200"
      raise MediaNotFoundError, "Media not found. Apparently."
    else
      return (args[:json] ? JSON.parse(response.body) : response.body)
    end
  end
  
  def self.get_my_recent_media
    handle IGNetworking::Request.get("users/self/feed", :count => 40), :json => true
  end
  
  def self.get_user_info user_id
    handle IGNetworking::Request.get("/users/#{user_id}"), :json => true
  end
  
  def self.get_user_feed user_id
    handle IGNetworking::Request.get("/users/#{user_id}/media/recent"), :json => true
  end
  
  def self.get_media_data media_id
    handle IGNetworking::Request.get("media/#{media_id}"), :json => true
  end
  
  def self.get_media_likes media_id
    handle IGNetworking::Request.get("media/#{media_id}/likes"), :json => true
  end
  
  def self.get_media_comments media_id
    handle IGNetworking::Request.get("media/#{media_id}/comments"), :json => true
  end
  
  def self.like_media media_id
    handle IGNetworking::Request.post("media/#{media_id}/likes/")
  end
  
  def self.unlike_media media_id
    handle IGNetworking::Request.delete("media/#{media_id}/likes/")
  end
  
end
