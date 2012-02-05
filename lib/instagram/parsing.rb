require 'json'
require 'instagram/parsing/session'
require 'instagram/parsing/feeds'
require 'instagram/parsing/photo'
require 'instagram/parsing/likes_list'

module Instagram
  module Parsing
    def self.can_decode? response
      true if response.code.to_i == 200 and is_json?(response.body)
    end

    def self.is_json? data
      true if JSON.parse data
    rescue
      false
    end

    def self.decode response
      yield JSON.parse(response.body, { :symbolize_names => true }) if can_decode? response
    end
  end
end
