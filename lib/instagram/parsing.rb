require 'instagram/parsing/parser'
require 'instagram/parsing/api_response'
require 'instagram/parsing/likes_list'
require 'instagram/parsing/paged_media_feed'
require 'instagram/parsing/photo'
require 'instagram/parsing/post_comment_response'
require 'instagram/parsing/session'
require 'instagram/parsing/static_media_feed'
require 'instagram/parsing/user'
require 'instagram/parsing/users_list'
require 'json-schema'
require 'yajl'

module Instagram
  module Parsing
    def self.can_decode? response, schema
      response.code.to_i == 200 && is_valid_json?(response.body, schema)
    end

    def self.is_valid_json? json, schema
      JSON::Validator.json_backend = :yajl
      JSON::Validator.validate! "lib/instagram/schemas/#{schema}.json", json
    end

    def self.decode response, schema
      yield Yajl::Parser.new(:symbolize_keys => true).parse(response.body) if can_decode?(response, schema)
    end
  end
end
