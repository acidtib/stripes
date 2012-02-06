require 'instagram/models/user'

module Instagram
  class Comment
    attr_reader :id, :text, :created_time
    attr_accessor :from

    def initialize fields = {}
      @id = fields[:id].to_i
      @text = fields[:text]
      @from = Instagram::User.new fields[:from] if fields[:from]
      @created_time = Time.at fields[:created_time].to_i
    end

    alias_method :instagram_id, :id
    alias_method :created_at, :created_time
    alias_method :user, :from
  end
end
