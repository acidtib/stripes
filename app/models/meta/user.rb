class Meta::User
  
  attr_reader :username, :profile_picture_url, :id, :full_name
  
  def initialize data
    @username = data["username"]
    @profile_picture_url = data["profile_picture"]
    @id = data["id"]
    @full_name = data["full_name"]
  end
  
end