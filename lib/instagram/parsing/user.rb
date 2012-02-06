require 'instagram/models/full_user'

module Instagram
  module Parsing
    class User
      def self.parse response
        Parsing.decode(response) do |data|
          Instagram::FullUser.new data[:data]
        end
      end
    end
  end
end
