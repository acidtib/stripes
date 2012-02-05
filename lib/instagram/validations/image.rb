require 'instagram/validation'

module Instagram
  module Validation
    class Image
      extend Validation

      def self.valid? data
        hash_and_not_empty?(data)
      end
    end
  end
end
