require 'instagram/parsing'
require 'instagram/auth_requests/authentication'
require 'instagram/api_requests/feeds'
require 'instagram/api_requests/media'

module Instagram
  def self.authorize code
    Parsing::Session.parse Request::Authentication.request_access(code)
  end

  def self.authentication_url
    "https://instagram.com" + Request::Authentication.authentication_url    
  end

  def self.get_my_feed token
    Parsing::MediaFeed.parse Request::MediaFeed.get_authorized_user_feed(token)
  end

  def self.get_my_feed_from_max_id token, max_media_id
    Parsing::MediaFeed.parse Request::MediaFeed.get_authorized_user_feed_page(token, max_media_id)
  end

  def self.get_media token, media_id
    Parsing::Photo.parse Request::Media.get_media(token, media_id)
  end

  def self.get_media_likes token, media_id
    Parsing::LikesList.parse Request::Media.get_likes(token, media_id)
  end

  def self.get_media_comments token, media_id
    Parsing::CommentsList.parse Request::Media.get_comments(token, media_id)
  end
end
