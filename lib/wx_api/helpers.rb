module WxApi
    module Helpers

        def render_json(json={})
            JSON.generate({:status => 0, :msg => "success."}.merge(json))
        end

        def redirect_logto(url)
            raise RuntimeError, "Need current_user first!" if !current_user
            "#{request.scheme}://#{request.host_with_port}/wx/logto?user_credentials=#{current_user.single_access_token}&to=#{CGI.escape(url)}"
        end
        
        def is_pad?
            ['android pad','ipad'].include? ( (env['__DEVICE']&&env['__DEVICE'].downcase)||(params[:device]&&params[:device].downcase) )
        end
    end

end
