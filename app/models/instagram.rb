class Instagram
  
  def self.handle response, args = {}
    unless args[:suppress_errors]
      unless response.code == "200"
        case response.code
        when "400"
          raise BadRequestError
        when "404"
          raise NotFoundError
        when "500"
          raise InternalServerError
        when "503"
          raise ServiceUnavailableError
        end
      end
    end

    return (args[:json] ? JSON.parse(response.body) : response.body)
  end
  
  def self.get_my_recent_media next_max_id = nil
    data = handle IGNetworking::Request.get("users/self/feed", :count => 20, :max_id => next_max_id), :json => true
    return data["data"].collect do |m| Meta::Photo.new m end, data["pagination"].empty? ? "" : data["pagination"]["next_max_id"]
  end
  
  def self.get_popular_media
    data = handle IGNetworking::Request.get("media/popular"), :json => true
    return data["data"].collect do |m| Meta::Photo.new m end
  end
  
  def self.get_user user_id
    data = handle IGNetworking::Request.get("/users/#{user_id}"), :json => true
    return Meta::ExtendedUser.new data["data"]
  end
  
  def self.get_user_feed user_id, next_max_id = nil
    data = handle IGNetworking::Request.get("/users/#{user_id}/media/recent", :count => 20, :max_id => next_max_id), :json => true
    return data["data"].collect do |m| Meta::Photo.new m end, data["pagination"].empty? ? "" : data["pagination"]["next_max_id"]
  end
  
  def self.get_media media_id # get general information about media
    data = handle IGNetworking::Request.get("media/#{media_id}"), :json => true
    return Meta::Photo.new data["data"]
  end
  
  def self.get_media_likes media_id
    data = handle IGNetworking::Request.get("media/#{media_id}/likes"), :json => true
    return data["data"].collect do |l| Meta::User.new l end
  end
  
  def self.get_media_comments media_id
    data = handle IGNetworking::Request.get("media/#{media_id}/comments"), :json => true
    return data["data"].collect do |c| Meta::Comment.new c end
  end
  
  def self.like_media media_id
    handle IGNetworking::Request.post("media/#{media_id}/likes/")
  end
  
  def self.unlike_media media_id
    handle IGNetworking::Request.delete("media/#{media_id}/likes/")
  end

  def self.search_users query
    data = handle IGNetworking::Request.get("users/search", :q => query), :json => true
    return false if data["data"].empty?
    data["data"].collect do |l| Meta::User.new l end
  end

  # now some user relationship handling
  def self.get_relationship_status user_id
    data = handle IGNetworking::Request.get("users/#{user_id}/relationship"), :json => true
    return Meta::UserRelation.new data["data"]
  end

  def self.follow_user user_id
    handle IGNetworking::Request.post("users/#{user_id}/relationship", :action => "follow"), :suppress_errors => true
  end

  def self.unfollow_user user_id
    handle IGNetworking::Request.post("users/#{user_id}/relationship", :action => "unfollow"), :suppress_errors => true
  end
  
end
