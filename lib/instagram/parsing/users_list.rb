require 'instagram/models/user'

module Instagram
  module Parsing
    class UsersList
      def self.parse response
        Parsing.decode(response) do |data|
          data[:data].collect do |like| Instagram::User.new like end
        end
      end
    end
  end
end
