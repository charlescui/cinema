require_dependency "api/application_controller"

module Api
  class V1::SegmentController < ApplicationController
    def index
        @count = Media::Segment.count
        @eye_count = current_eye.segments.count
        @current_segment = Media::Segment.get_current_segment(current_eye.id)

        render_json(:data => {
            total: @count,
            eye_count: @eye_count,
            current_segment: @current_segment.as_json
            })
    end

    def show
        
    end

    def create
        if current_user and params[:id] and (current_eye = current_user.eyes.where(:id => params[:id]).first)
            segment = current_eye.segments.new
            segment.duration = params[:duration] 
            segment.segment = params[:segment] 
            segment.comment = params[:comment] 
            segment.byterange_length = params[:byterange_length] 
            segment.byterange_start = params[:byterange_start]
            segment.timestamp = params[:timestamp]
            segment.eye_id = current_eye.id
            if segment.save
                render_json
            else
                render_json :stsatus => -1, :msg => segment.errors.inspect
            end
        else
            render_json :status => -999, :msg => "need login"
        end
    end

    def delete
        
    end
  end
end
