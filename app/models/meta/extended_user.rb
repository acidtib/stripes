class Meta::ExtendedUser < Meta::SourceUser
  
  attr_reader :followers, :following, :media_count
  
  def initialize data
    super
    @media_count = data["counts"]["media"]
    @followers = data["counts"]["followed_by"]
    @following = data["counts"]["follows"]
  end
  
end