require 'settings'
require 'instagram/networking/api'

module Instagram
  module Request
    class MediaFeed
      def get_user_media_feed user_instagram_id
        
      end

      def self.get_authorized_user_feed token
         API.get "users/self/feed", token, { :count => Settings.instagram.photos_per_feed_page }
      end

      def self.get_authorized_user_feed_page token, max_id
         API.get "users/self/feed", token, { :count => Settings.instagram.photos_per_feed_page, :max_id => max_id }
      end

      def get_popular_feed
        
      end

      def get_search_feed query
        
      end
    end
  end
end
