require 'instagram/models/extended_user'

module Instagram
  class FullUser < ExtendedUser
    attr_reader :media_count, :followers, :following

    def initialize data
      super
      @media_count = data[:counts][:media]
      @followers = data[:counts][:followed_by]
      @following = data[:counts][:follows]
    end
  end
end
