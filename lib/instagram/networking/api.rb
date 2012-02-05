require "uri"
require "net/http"
require "net/https"

module Instagram
  class API
    def self.new_http
      http = Net::HTTP.new Settings.instagram.api.server_url, Settings.instagram.api.server_port
      http.use_ssl = true if Settings.instagram.api.ssl_required
      return http
    end

    def self.parametrize params_hash = {}
      params_hash.nil? ? "" : params_hash.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" unless v.nil? }.join('&')
    end

    def self.build_request_path request, token = nil, params = nil
      "#{Settings.instagram.api.root_path}#{request}?#{(token ? 'access_token='+token+'&' : '')}#{parametrize(params)}"
    end

    def self.get request, token, params = {}
      new_http.get build_request_path(request, token, params)
    end

    def self.post request, token, params = {}
      params[:access_token] = token
      new_http.post build_request_path(request), parametrize(params)
    end

    def self.delete request, token
      new_http.delete build_request_path(request, token)
    end
  end
end
