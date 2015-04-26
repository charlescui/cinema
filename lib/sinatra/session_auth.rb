require 'authlogic/controller_adapters/sinatra_adapter'
module Sinatra
  module SessionAuth
    module Helpers
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.record
      end
       
      def require_user
        controller = Authlogic::ControllerAdapters::SinatraAdapter::Controller.new(request, response)
        Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::SinatraAdapter::Adapter.new(controller)
        halt 401, {'Content-Type' => 'text/plain'}, "unauthorized!!!" unless current_user
      end
    end
    
    def self.registered(app)
      app.helpers Helpers
    end
  end
end