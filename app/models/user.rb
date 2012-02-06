class User < ActiveRecord::Base

  validates :instagram_id, :username, :presence => true
  validates :instagram_id, :format => { :with => /^(\d*)$/, :message => "Only numbers are allowed." }
  validates :instagram_id, :numericality => { :greater_than => 0 }

  validates :username, :format => { :with => /^[a-zA-Z\d_]*$/, :message => "Only latin numbers, letters and underscores are allowed." }
  validates :username, :length => { :in => 1..30 }

  # Can I refactor something here?!

  def self.create_or_update instagram_id, username
    user = User.find_or_initialize_by_instagram_id instagram_id
    if user.username != username do user.username = username end
    user.save
  end

  def self.cache_data *args
    args.each do |arg|
      arg.kind_of?(Array) ? cache_data arg : update_or_create_cache arg
    end
  end

  def self.update_or_create_cache item
    if item.kind_of? Instagram::User
      instagram_id = data.instagram_id
      username = data.username
    elsif item.kind_of?(Instagram::Photo) or item.kind_of?(Instagram::Comment)
      instagram_id = item.from.instagram_id
      username = item.from.username
    end
    create_or_update instagram_id, username
  end

  def self.find_by_username_or_id thing
    find_by_username(params[:username]) || find_by_instagram_id(params[:username].to_i)
  end

end
