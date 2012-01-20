class Meta::SourceUser < Meta::User
  
  attr_reader :website, :bio
  
  def initialize data
    super
    @website = data["website"]
    @bio = data["bio"]
  end
  
end