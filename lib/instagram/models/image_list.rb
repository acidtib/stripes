require 'instagram/models/media_list'

module Instagram
  class ImageList < MediaList
    # regarding the dynamic nature of creating instance variables
    # in MediaList, we have to make alias_methods dynamic too
    def initialize data
      super data
      class_eval do
        # backward compability actually but maybe worth keeping
        alias_method :small, :thumbnail
        alias_method :medium, :low_resolution
        alias_method :large, :standard_resolution
      end
    end
  end
end
