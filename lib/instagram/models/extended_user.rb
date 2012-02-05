require 'instagram/models/user'

module Instagram
  class ExtendedUser < User
    attr_accessor :bio, :website

    def initialize fields
      super fields
      @bio = fields[:bio]
      @website = fields[:website]
    end
  end
end
