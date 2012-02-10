require 'instagram/models/photo'

module Instagram
  module Parsing
    class StaticMediaFeed < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          data[:data].collect do |photo| Instagram::Photo.new photo end
        end
      end
    end
  end
end
