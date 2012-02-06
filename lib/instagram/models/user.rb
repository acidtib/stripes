module Instagram
  class User
    attr_reader :id, :username, :profile_picture, :full_name

    def initialize fields = {}
      @id = fields[:id].to_i
      @username = fields[:username]
      @profile_picture = fields[:profile_picture]
      @full_name = fields[:full_name]
    end

    alias_method :instagram_id, :id
    alias_method :profile_picture_url, :profile_picture
  end
end
