module Instagram
  class Relationship
    attr_reader :outgoing, :private, :incoming
  
    def initialize data
      @outgoing = data[:outgoing_status]
      @private = data[:target_user_is_private]
      @incoming = data[:incoming_status]
    end
  end
end
