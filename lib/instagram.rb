require 'instagram/parsing'
require 'instagram/request'

module Instagram
  # Authentication
  def self.authorize code
    Parsing::Session.parse Request::Authentication.request_access(code)
  end

  def self.authentication_url
    "https://instagram.com" + Request::Authentication.authentication_url
  end

  # User's feed of images from people user is following and pagination function
  def self.get_my_feed token
    Parsing::PagedMediaFeed.parse Request::MediaFeed.get_authorized_user_feed(token)
  end

  def self.get_my_feed_from_max_id token, max_media_id
    Parsing::PagedMediaFeed.parse Request::MediaFeed.get_authorized_user_feed_page(token, max_media_id)
  end

  # Media data fetching
  def self.get_media token, media_id
    Parsing::Photo.parse Request::Media.get_media(token, media_id)
  end

  def self.get_media_likes token, media_id
    Parsing::LikesList.parse Request::Media.get_likes(token, media_id)
  end

  def self.get_media_comments token, media_id
    Parsing::CommentsList.parse Request::Media.get_comments(token, media_id)
  end

  def self.get_popular_media token
    Parsing::StaticMediaFeed.parse Request::MediaFeed.get_popular_feed(token)
  end

  # Media actions
  def self.like_media token, media_id
    Parsing::APIResponse.parse Request::Media.like(token, media_id)
  end

  def self.unlike_media token, media_id
    Parsing::APIResponse.parse Request::Media.unlike(token, media_id)
  end

  def self.comment_on_media token, media_id, text
    Parsing::PostCommentResponse.parse Request::Media.post_comment(token, media_id, text)
  end

  # User data fetching
  def self.get_user_info token, user_id
    Parsing::User.parse Request::User.get_info(token, user_id)
  end

  def self.get_user_relationship token, user_id
    Parsing::Relationship.parse Request::User.get_relationship(token, user_id)
  end

  def self.get_user_feed token, user_id # this gets user's recent media
    Parsing::PagedMediaFeed.parse Request::User.get_feed(token, user_id)
  end

  def self.get_user_feed_from_max_id token, user_id, max_media_id
    Parsing::PagedMediaFeed.parse Request::User.get_feed_page_from_max_id(token, user_id, max_media_id)
  end

  # User actions
  def self.follow_user token, user_id
    Parsing::APIResponse.parse Request::User.follow token, user_id
  end

  def self.unfollow_user token, user_id
    Parsing::APIResponse.parse Request::User.unfollow token, user_id
  end

  # Searches
  def self.search_users token, query
    Parsing::UsersList.parse Request::User.search token, query
  end
end
