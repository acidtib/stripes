module Instagram
  module Validation
    def hash? object
      object.kind_of? Hash
    end

    def not_empty? object
      (object.respond_to?(:empty?) and not object.empty?) ? true : false
    end

    def hash_and_not_empty? object
      (hash?(object) and not_empty?(object)) ? true : false
    end

    def hash_and_has_keys? object, keys = {}
      # TODO
    end
  end
end
