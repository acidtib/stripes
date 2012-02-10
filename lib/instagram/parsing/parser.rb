module Instagram
  module Parsing
    class Parser
      def self.self_schema_name
        name.split("::").last.
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
      end

      def self.validate_and_parse response
        yield Parsing.decode(response, self_schema_name)
      end
    end
  end
end