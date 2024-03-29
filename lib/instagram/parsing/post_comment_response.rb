require 'instagram/models/api_response'
require 'instagram/models/comment'

module Instagram
  module Parsing
    class PostCommentResponse < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          resp = Instagram::APIResponse.new response.code.to_i, data
          return resp, ( Instagram::Comment.new(data[:data]) if resp.ok? )
        end
      end
    end
  end
end
