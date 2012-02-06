require 'settings'
require 'instagram/networking/api'

module Instagram
  module Request
    class User
      def self.get_info token, instagram_id
        API.get "users/#{instagram_id}", token
      end

      def self.get_feed token, instagram_id
        API.get "users/#{instagram_id}/media/recent", token, { :count => Settings.instagram.photos_per_feed_page }
      end

      def self.get_feed_page_from_max_id token, instagram_id, max_id
        API.get "users/#{instagram_id}/media/recent", token, { :count => Settings.instagram.photos_per_feed_page, :max_id => max_id }
      end

      def self.get_relationship token, instagram_id
        API.get "users/#{instagram_id}/relationship", token
      end

      def self.search token, query
        API.get "users/search", token, { :q => query }
      end
    end
  end
end
