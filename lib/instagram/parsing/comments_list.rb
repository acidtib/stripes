require 'instagram/models/comment'

module Instagram
  module Parsing
    class CommentsList
      def self.parse response
        Parsing.decode(response) do |data|
          data[:data].collect do |c| Instagram::Comment.new c end
        end
      end
    end
  end
end
