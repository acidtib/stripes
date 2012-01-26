class User < ActiveRecord::Base

  validates :instagram_id, :username, :presence => true
  validates :instagram_id, :format => { :with => /^(\d*)$/, :message => "Only numbers are allowed." }
  validates :instagram_id, :numericality => { :greater_than => 0 }

  validates :username, :format => { :with => /^[a-zA-Z\d_]*$/, :message => "Only latin numbers, letters and underscores are allowed." }
  validates :username, :length => { :in => 1..30 }

  def self.create_or_update instagram_id, username
    item = User.new :instagram_id => instagram_id, :username => username
    return false unless item.valid? # little firewall from crap

    cache = User.find_by_instagram_id item.instagram_id

    if cache
      if cache.username != username
        cache.username = username
        cache.save!
      end
    else
      User.create :username => username, :instagram_id => instagram_id
    end
  end

  def self.cache_data *args
    args.each do |arg|
      if arg.kind_of? Array
        arg.each do |a| detect_data_and_cache a end
      else
        detect_data_and_cache arg
      end
    end
  end

  def self.detect_data_and_cache data
    instagram_id = -1
    u = ''

    if data.kind_of? Meta::User
      instagram_id = data.id.to_i
      username = data.username
    elsif data.kind_of?(Meta::Photo) or data.kind_of?(Meta::Comment)
      instagram_id = data.user.id.to_i
      username = data.user.username
    end

    create_or_update instagram_id, username
  end

end