require 'instagram/models/photo'

module Instagram
  module Parsing
    class StaticMediaFeed
      def self.parse response
        Parsing.decode(response) do |data|
          data[:data].collect do |photo| Instagram::Photo.new photo end
        end
      end
    end
  end
end
