require 'instagram/models/media'

module Instagram
  class MediaList  
    def initialize data
      data.each do |k, v| # TODO: implement validation?
        class_eval do attr_reader k.to_s end
        instance_variable_set "@#{k.to_s}".to_sym, Media.new(v)
      end
    end
  end
end
