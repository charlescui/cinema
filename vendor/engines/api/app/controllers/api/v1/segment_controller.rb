require_dependency "api/application_controller"

module Api
  class V1::SegmentController < ApplicationController
    def index
        
    end

    def show
        
    end

    def create
        if current_eye
            segment = current_eye.segments.create(params)
        end
    end

    def delete
        
    end
  end
end
