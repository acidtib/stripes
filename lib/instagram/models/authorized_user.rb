require 'instagram/models/user'

module Instagram
  class AuthorizedUser < User
    attr_accessor :access_token

    def initialize fields, token
      super fields
      @access_token = token
    end
  end
end
