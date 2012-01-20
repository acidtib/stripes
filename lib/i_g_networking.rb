module IGNetworking
  
  require "uri"
  require "net/http"
  require "net/https"
  
  class Request
  
    def self.params2str params
      params.delete_if { |k, v| v == "" }
      "&" + params.map{ |k, v| "#{k}=#{v}" }.join("&")
    end

    def self.get request, params = nil
      @http.get("/v1/#{request}?access_token=#{@access_token}#{params ? params2str(params) : ''}")
    end

    def self.post request, params = nil
      @http.post("/v1/#{request}", "access_token=#{@access_token}#{params ? params2str(params) : ''}")
    end

    def self.delete request, params = nil
      @http.delete("/v1/#{request}?access_token=#{@access_token}#{params ? params2str(params) : ''}")
    end
  
    def self.init access_token
      raise "No correct access token provided." unless access_token # this bullshit should be rewritten
      @access_token = access_token
      @http = Net::HTTP.new 'api.instagram.com', 443
      @http.use_ssl = true
    end
    
    def self.halt
      @access_token = nil
    end
    
  end
  
  class OAuth

     CLIENT_ID = '5b94ab73a59145be939858ad04be772d'
     CLIENT_SECRET = '800e0c7c46c243a48ece23d022ce25d0'
     REDIRECT_URI = 'http://localhost:3000/auth'
     SCOPE = 'basic+relationships+comments+likes'

     def self.request_auth_url
       "https://api.instagram.com/oauth/authorize/?" + { :client_id => CLIENT_ID, :redirect_uri => REDIRECT_URI, :response_type => "code" }.to_query + "&scope=" + SCOPE
     end

     def self.authorize code
       http = Net::HTTP.new 'api.instagram.com', 443
       http.use_ssl = true
       path = '/oauth/access_token'

       response = http.post(path, {:client_id => CLIENT_ID, 
                                   :client_secret => CLIENT_SECRET, 
                                   :grant_type => "authorization_code", 
                                   :code => code, 
                                   :redirect_uri => REDIRECT_URI}.to_query)

       case response
       when Net::HTTPSuccess, Net::HTTPRedirection
         return response.body
       else
         response.error!
       end
     end

   end
  
end