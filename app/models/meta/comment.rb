class Meta::Comment
  
  attr_reader :user, :text, :created_at
  
  def initialize data
    @user = Meta::User.new data["from"]
    @created_at = Time.at data["created_time"].to_i
    @text = data["text"]
  end
  
end