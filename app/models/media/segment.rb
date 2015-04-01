class Media::Segment < ActiveRecord::Base
    include ActiveModel::Serializers::JSON
    # attr_access :duration, :segment, :comment, :byterange_length, :byterange_start, :timestamp, :eye_id, :seq

    belongs_to :eye
    before_save :update_segment_seq
    after_save  :update_current_segment
    
    CURRENRSEGMENTKEY = "CURRENRSEGMENTKEY"

    # 每个片段都与属于自己的序列
    # 而这个序列的计数器则是eye模型中的seq字段
    def update_segment_seq
        # 当本片段存在Eye，并且还没有更新过Seq时，执行以下逻辑
        if self.eye and (!self.seq or (self.seq == 0))
            self.eye.seq ||= 0
            self.seq = self.eye.seq
            self.eye.seq += 1
            self.eye.save
        end
    end

    def update_current_segment
        if !@_has_update_current_segment
            @_has_update_current_segment = true
            self.class.update_current_segment(self)
        end
    end

    def self.update_current_segment(segment)
        Rails.cache.write("#{CURRENRSEGMENTKEY}::#{segment.eye_id}", segment.as_json)
    end

    def self.get_current_segment(eye_id)
        data = Rails.cache.fetch("#{CURRENRSEGMENTKEY}::#{eye_id}", :expires_in => 30){
            s = self.where(:eye_id => eye_id).order("timestamp DESC").limit(1)
            s and s.as_json
        }
        if data
            segment = self.find(data["id"])
        else
            nil
        end
    end

    # 直播时寻找视频片段
    def self.segments_live(eye_id, n=3)
        Media::Segment.limit(n).order("created_at DESC").reverse
    end

    # 回放时寻找视频片段
    def self.segments_from(eye_id, ts, n=10)
        self.where(:eye_id => eye_id).where(" ts >= ? ", ts).order("timestamp ASC").limit(n)
    end

    def self.live_m3u8_tmpl
        @_live_m3u8_tmpl ||= <<-DOC
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:YES
#EXT-X-MEDIA-SEQUENCE:<%= seq %>
#EXT-X-TARGETDURATION:<%= max_duration %>
<% segments.each do|item| %>
#EXTINF:<%= item.duration %>,
<%= item.segment %>
<% end %>
DOC
    end

    def self.live_m3u8_tmpl_erb
        @_live_m3u8_tmpl_erb ||= ERB.new(live_m3u8_tmpl)
    end

    def self.play_back_m3u8_tmpl
        @_play_back_tmpl ||= <<-DOC
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-ALLOW-CACHE:YES
#EXT-X-MEDIA-SEQUENCE:<%= seq %>
#EXT-X-TARGETDURATION:<%= max_duration %>
<% segments.each do|item| %>
#EXTINF:<%= item.duration %>,
<%= item.segment %>
<% end %>
#EXT-X-ENDLIST
DOC
    end

    def self.play_back_tmpl_erb
        @_play_back_tmpl_erb ||= ERB.new(play_back_tmpl)
    end
end
