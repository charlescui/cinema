class Eye < ActiveRecord::Base
    acts_as_authentic
    has_many :segments, class_name: "Media::Segment"

    LIVESEGMENTS = 1 #直播的请求，返回一个最新的视频片段
    PLAYBACKSEGMENTS = 1 * 60 * 60 / 10 #每个回放的请求,限制返回一小时的视频list

    def live_m3u8
        segments = Media::Segment.segments_live(self.id, LIVESEGMENTS).reverse.map { |e| 
            Media::Segment.new.from_json(e) 
        }

        self.class.to_m3u8(segments)
    end

    def play_back_m3u8(ts)
        segments = Media::Segment.segments_from(self.id, ts, PLAYBACKSEGMENTS).reverse.map { |e| 
            Media::Segment.new.from_json(e) 
        }

        self.class.to_m3u8(segments, false)
    end

    def self.to_m3u8(segments, live=true)
        seq = segments.first.seq
        max_duration = segments.map{ |e| e.duration }.max.floor
        erb = live ? Media::Segment.live_m3u8_tmpl_erb : Media::Segment.play_back_m3u8_tmpl_erb
        erb.result(binding).gsub("\n\n", "\n")
    end
end
