require 'instagram/models/photo'

module Instagram
  module Parsing
    class Photo
      def self.parse response
        Parsing.decode(response) do |data|
          Instagram::Photo.new data[:data]
        end
      end
    end
  end
end