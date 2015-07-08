require_dependency "api/application_controller"

module Api
  class V1::EyeController < ApplicationController
    def register
        # 如果没有登录状态
        if !current_eye
            if (eye_uuid = params[:eye_uuid])
                if (current_eye = Eye.where(:uuid => eye_uuid).first)
                    # 如果已注册
                    # nothing
                else
                    # 如果未注册
                    params.permit!
                    current_eye = Eye.new(params)
                    passwd = SecureRandom.hex[0..15]
                    current_eye.password = current_eye.password_confirmation = passwd
                    current_eye.reset_single_access_token!
                end
            else
                render_json(:status => -1, :msg => "need eye_uuid params")
                return
            end
        end
        render_json(:data => {:token => current_eye.single_access_token})
    end

    def live
        if current_eye
            render :text => current_eye.live_m3u8
        else
            render_json(status: -1, msg: "no eye found!")
        end
    end

    def play_back
        if current_user and params[:id] and (current_eye = current_user.eyes.where(:id => params[:id]).first)
            ts = params[:ts] || 1.hour.ago.to_i
            render :text => current_eye.play_back_m3u8(ts)
        else
            render_json(status: -1, msg: "no eye found!")
        end
    end
  end
end
