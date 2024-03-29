class User < ActiveRecord::Base
  validates :instagram_id, :username, :presence => true
  validates :instagram_id, :format => { :with => /^(\d*)$/, :message => "Only numbers are allowed." }
  validates :instagram_id, :numericality => { :greater_than => 0 }
  validates :instagram_id, :uniqueness => true
  validates :username, :format => { :with => /^[a-zA-Z\d_]*$/, :message => "Only latin numbers, letters and underscores are allowed." }
  validates :username, :length => { :in => 1..30 }

  def self.create_from_meta user
    self.create :instagram_id => user.id, :username => user.username
  end
end
