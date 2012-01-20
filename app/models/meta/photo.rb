class Meta::Photo
  
  attr_reader :filter, :created_at, :link,
              :title, :user,
              :image, :location,
              :id, :i_have_liked,
              :likes, :comments,
              :likes_count,
              :comments_count
                
  
  def initialize data
    @location = Meta::Location.new(data["location"]["latitude"], data["location"]["longitude"]) if data["location"]
    @id = data["id"]
    @created_at = Time.at data["created_time"].to_i
    @image = Meta::ImageData.new data["images"]
    @title = data["caption"]["text"] if data["caption"]
    @filter = data["filter"]
    @user = Meta::SourceUser.new data["user"]
    @i_have_liked = data["user_has_liked"]
    @likes_count = data["likes"]["count"].to_i
    @comments_count = data["comments"]["count"].to_i
  end
    
end