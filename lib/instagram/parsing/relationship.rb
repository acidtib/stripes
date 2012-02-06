require 'instagram/models/relationship'

module Instagram
  module Parsing
    class Relationship
      def self.parse response
        Parsing.decode(response) do |data|
          Instagram::Relationship.new data[:data]
        end
      end
    end
  end
end