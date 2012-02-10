require 'instagram/models/api_response'

module Instagram
  module Parsing
    class APIResponse < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          Instagram::APIResponse.new response.code.to_i, data
        end
      end
    end
  end
end
