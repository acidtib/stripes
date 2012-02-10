require 'instagram/models/photo'

module Instagram
  module Parsing
    class Photo < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          Instagram::Photo.new data[:data]
        end
      end
    end
  end
end