module Instagram
  class Location
    attr_reader :longitude, :latitude, :id, :name

    def initialize fields = {}
      super
      @longitude = fields[:longitude].to_f
      @latitude = fields[:latitude].to_f
      @name ||= fields[:name]
      @id ||= fields[:id]
    end

    alias_method :instagram_id, :id
    alias_method :x, :latitude
    alias_method :y, :longitude
  end
end
