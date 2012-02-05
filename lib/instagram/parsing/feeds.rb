require 'instagram/models/photo'

module Instagram
  module Parsing
    class MediaFeed
      def self.parse response
        Parsing.decode(response) do |data|
          photos = data[:data].collect do |photo| Instagram::Photo.new photo end
          next_page_max_id = data[:pagination][:next_max_id]
          return photos, next_page_max_id
        end
      end
    end
  end
end
