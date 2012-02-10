require 'instagram/models/authorized_user'

module Instagram
  module Parsing
    class Session < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          Instagram::AuthorizedUser.new data[:user], data[:access_token]
        end
      end
    end
  end
end