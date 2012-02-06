module Instagram
  require 'instagram/models/location'
  require 'instagram/models/image_list'
  require 'instagram/models/extended_user'
  require 'instagram/validations/location'

  class Photo
    attr_reader :id, :user_has_liked, :filter, :likes_count, :comments_count, :caption,
      :user, :location, :media, :created_time

    def initialize fields = {}
      # usual photo id looks like '667953848_7552748'
      #                            ^photo    ^user
      # let's normalize it since API currently accespts just photo IDs
      @id = fields[:id].match(/^(\d*)_(\d*)$/)[1].to_i

      # trivial properties
      @user_has_liked = fields[:user_has_liked]
      @filter = fields[:filter]
      @type = fields[:type]
      @created_time = Time.at fields[:created_time].to_i

      # trivial properties from inline data structures
      @likes_count = fields[:likes][:count]
      @comments_count = fields[:comments][:count]
      @caption = fields[:caption][:text] if fields[:caption]

      # complex properties as objects
      @user = ExtendedUser.new fields[:user]
      @location = Location.new(fields[:location]) if Validation::Location.valid?(fields[:location])
      @media = ImageList.new fields[:images]
    end

    alias_method :instagram_id, :id
    alias_method :liked, :user_has_liked
    alias_method :created_by, :user
    alias_method :created_at, :created_time
    alias_method :title, :caption
    alias_method :image, :media
  end
end
