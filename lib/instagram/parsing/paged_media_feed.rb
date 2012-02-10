require 'instagram/models/photo'

module Instagram
  module Parsing
    class PagedMediaFeed < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          photos = data[:data].collect do |photo| Instagram::Photo.new photo end
          next_page_max_id = data[:pagination][:next_max_id]
          return photos, next_page_max_id
        end
      end
    end
  end
end
