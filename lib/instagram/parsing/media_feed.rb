require 'instagram/models/photo'

module Instagram
  module Parsing
    class PagedMediaFeed
      def self.parse response
        Parsing.decode(response) do |data|
          photos = data[:data].collect do |photo| Instagram::Photo.new photo end
          return photos, (data[:pagination][:next_max_id] if data[:pagination])
        end
      end
    end
  end
end
