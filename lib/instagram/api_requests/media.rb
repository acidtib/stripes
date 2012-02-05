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
    end
  end
end
