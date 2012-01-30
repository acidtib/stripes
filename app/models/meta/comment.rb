class Meta::Comment
  
  attr_reader :user, :text, :created_at, :id
  attr_writer :user
  
  def initialize data
    @user = Meta::User.new data["from"] if data["from"]
    @created_at = Time.at data["created_time"].to_i
    @text = data["text"]
    @id = data["id"]
  end

  def set_user user
    @user = user
  end
  
end