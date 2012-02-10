require 'instagram/models/comment'

module Instagram
  module Parsing
    class CommentsList < Parser
      def self.parse response
        Parsing.decode(response, self_schema_name) do |data|
          data[:data].collect do |c| Instagram::Comment.new c end
        end
      end
    end
  end
end
