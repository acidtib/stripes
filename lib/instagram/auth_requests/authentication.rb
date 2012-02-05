require 'instagram/networking/oauth'
require 'settings'

module Instagram 
  module Request
    class Authentication
      def self.authentication_url
        OAuth.build_request_path "authorize/", { 
          :client_id => Settings.instagram.oauth.client_id,
          :redirect_uri => Settings.instagram.oauth.redirect_uri,
          :response_type => "code",
          :scope => Settings.instagram.oauth.scope
        }
      end

      def self.request_access code
        OAuth.post "access_token", {
          :client_id => Settings.instagram.oauth.client_id,
          :client_secret => Settings.instagram.oauth.client_secret,
          :grant_type => "authorization_code",
          :code => code,
          :redirect_uri => Settings.instagram.oauth.redirect_uri
        }
      end
    end
  end
end
