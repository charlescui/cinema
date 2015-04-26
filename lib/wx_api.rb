$:.unshift File.join(File.dirname(__FILE__))
require "sinatra/base"
require "sinatra/session_auth"

module WxApi

    module RequireUser
        def self.registered(app)
            app.before do
                #Rails.logger.info "Sinatra path - #{request.path_info} : #{params.inspect}"
                unless request.path_info.match(not_require_routes_reg)
                    require_user
                end
            end

            app.helpers Helpers
        end

        module Helpers
            def not_require_routes_reg
                @not_require_routes_reg ||= Regexp.new("^(\/(#{not_require_routes.join('|')}))")
            end

            def not_require_routes
                []
            end
        end
    end

    autoload :Helpers, File.join(File.dirname(__FILE__), 'wx_api', 'helpers.rb')
    Dir[File.join(File.dirname(__FILE__), 'wx_api', '*/**/*.rb')].each{|rb| require rb}

    # 
    Rails.logger.instance_eval{
        alias :write :info
    }

    class BaseServer < Sinatra::Base
        helpers WxApi::Helpers
        
        error do
            'An error occured: ' + request.env['sinatra.error'].message
            Rails.logger.error("#{request.env['sinatra.error'].message}\n#{request.env['sinatra.error'].backtrace.join($/)}")
        end

        configure do
            enable :logging
            use Rack::CommonLogger, Rails.logger
        end
    end

    class ApiServer < BaseServer
        register Sinatra::SessionAuth
        # 用户认证过滤器
        register RequireUser

        get '/env' do
            env.to_s
        end

        get '/who' do
            `hostname`
        end
    end

    module V1
        class Server < ApiServer
            register WechatController
        end
    end

end
