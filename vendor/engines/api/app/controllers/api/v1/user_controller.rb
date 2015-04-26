require_dependency "api/application_controller"

module Api
  class V1::UserController < ApplicationController
    # 某个设备通过设备ID(eye_uuid)与当前登录用户绑定
    def bind
        if current_user and (eye_uuid = params[:eye_uuid])
            if @eye = Eye.where(:uuid => eye_uuid).first
                current_user.eyes << @eye
                render_json(:msg => "success add eye to user's", :data => current_user.eyes.map { |e| 
                    {
                        :id => e.id,
                        :uuid => e.uuid,
                        :name => e.name
                    }
                })
            else
                render_json :status => -1, :msg => "no such device found."
            end
        else
            render_json :status => -2, :msg => "not user or params"
        end
    end
  end
end
