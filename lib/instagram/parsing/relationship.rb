require 'instagram/models/relationship'

module Instagram
  module Parsing
    class Relationship < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          Instagram::Relationship.new data[:data]
        end
      end
    end
  end
end