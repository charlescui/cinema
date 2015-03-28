class Media::Segment < ActiveRecord::Base
    belongs_to :eye
    before_save :get_segment_seq
    after_save :save_to_redis

    # 每个片段都与属于自己的序列
    # 而这个序列的计数器则是eye模型中的seq字段
    def get_segment_seq
        self.seq = self.eye.seq
        self.eye.seq += 1
        self.eye.save
    end

    def save_to_redis
        $redis.zadd(eye_segment_redis_key, self.ts, self.to_json)
    end

    def eye_segment_redis_key
        self.class.eye_segment_redis_key(self.eye_id)
    end

    def self.eye_segment_redis_key(eye_id)
        @_eye_segment_redis_key ||= "Eye::#{eye_id}::Segments"
    end

    # 直播时寻找视频片段
    def self.segments_live(eye_id, n=3)
        $redis.zrevrangebyscore(eye_segment_redis_key(eye_id), "+inf", "-inf", :limit => [0, n])
    end

    # 回放时寻找视频片段
    def self.segments_from(eye_id, ts, n=3)
        $redis.zrevrangebyscore(eye_segment_redis_key(eye_id), "+inf", ts, :limit => [0, n])
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
