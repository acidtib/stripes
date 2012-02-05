require "uri"
require "net/http"
require "net/https"

module Instagram
  class OAuth
    def self.new_http
      http = Net::HTTP.new Settings.instagram.oauth.server_url, Settings.instagram.oauth.server_port
      http.use_ssl = true if Settings.instagram.oauth.ssl_required
      return http
    end

    def self.parametrize params_hash = {}, for_post = false
      params_hash.nil? ? "" : (for_post ? "" : "?").concat(params_hash.collect { |k,v| "#{k}=#{v.to_s}" }.join('&'))
    end

    def self.build_request_path request, params = nil
      "#{Settings.instagram.oauth.root_path}#{request}#{parametrize(params)}"
    end

    def self.get request, params = {}
      new_http.get build_request_path(request, params)
    end

    def self.post request, params = {}
      new_http.post build_request_path(request), parametrize(params, true)
    end
  end
end
