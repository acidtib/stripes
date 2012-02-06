require 'instagram/models/api_response'

module Instagram
  module Parsing
    class APIResponse
      def self.parse response
        Parsing.decode(response) do |data|
          Instagram::APIResponse.new response.code.to_i, data
        end
      end
    end
  end
end
