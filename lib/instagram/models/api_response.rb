module Instagram
  class APIResponse
    attr_accessor :ok, :message

    def ok?
      @ok
    end

    def initialize code, response
      if code == 200
        @ok = true
      else
        @ok = false
        @message = response[:meta][:error_message] if response and response.has_key?(:meta) and response[:meta].has_key?(:error_message)
      end
    end

    def []= key, data
      class_eval do attr_reader key.to_s end
      instance_variable_set "@#{key}".to_sym, data
    end

    def unset variable
      
    end
  end
end
