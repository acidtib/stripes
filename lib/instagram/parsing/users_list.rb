require 'instagram/models/user'

module Instagram
  module Parsing
    class UsersList < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          data[:data].collect do |like| Instagram::User.new like end
        end
      end
    end
  end
end
