require 'rack/request'

module Rack 
  class FacebookSession
  
    FACEBOOK_SESSION_KEY = 'fb_sig_session_key'
  
    def initialize(app, session_key =nil)
      @app = app
      @session_key = session_key ||  lambda { '_session_id' }
    end

    def call(env)
      req = Rack::Request.new(env)
      key = req.POST[FACEBOOK_SESSION_KEY] || req.GET[FACEBOOK_SESSION_KEY]
      env['HTTP_COOKIE'] = [ @session_key.call, key ].join('=').freeze unless key.nil?
    
      @app.call(env)
    end
  end
end