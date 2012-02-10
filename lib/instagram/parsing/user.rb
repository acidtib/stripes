require 'instagram/models/full_user'

module Instagram
  module Parsing
    class User < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          Instagram::FullUser.new data[:data]
        end
      end
    end
  end
end
