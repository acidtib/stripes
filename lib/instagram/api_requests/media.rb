require 'settings'
require 'instagram/networking/api'

module Instagram
  module Request
    class Media
      def self.get_media token, instagram_id
        API.get "media/#{instagram_id}", token
      end

      def self.get_likes token, instagram_id
        API.get "media/#{instagram_id}/likes", token
      end

      def self.get_comments token, instagram_id
        API.get "media/#{instagram_id}/comments", token
      end

      def self.like token, instagram_id
        API.post "media/#{instagram_id}/likes/", token
      end

      def self.unlike token, instagram_id
        API.delete "media/#{instagram_id}/likes/", token
      end

      def self.post_comment token, instagram_id, text
        API.post "media/#{instagram_id}/comments/", token, { :text => text }
      end
    end
  end
end
