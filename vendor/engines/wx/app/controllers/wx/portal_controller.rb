require_dependency "wx/application_controller"

module Wx
  class PortalController < ApplicationController
    def live
        
    end

    def demo
        if current_user and (eye_id = params[:eye_id])
            # if current_user.eyes.map{|e|e.id}.include?(eye_id)
                if !(@eye = Eye.find(eye_id))
                    render status: :not_found
                end
            # end
        else
            render status: :not_found
        end
    end
  end
end
