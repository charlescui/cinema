class Eye < ActiveRecord::Base
    acts_as_authentic do |c|
      c.crypto_provider = Authlogic::CryptoProviders::Sha512
    end
    include Uuidable
    
    has_many :segments, class_name: "Media::Segment"

    has_many :users, :class_name => "user", :through => :user_eye_ships
    has_many :user_eye_ships, :class_name => "user_eye_ship"

    LIVESEGMENTS = 1 #直播的请求，返回一个最新的视频片段
    PLAYBACKSEGMENTS = 1 * 60 * 60 / 10 #每个回放的请求,限制返回一小时的视频list

    def live_m3u8
        segments = Media::Segment.segments_live(self.id)

        self.class.to_m3u8(segments)
    end

    def play_back_m3u8(ts)
        segments = Media::Segment.segments_from(self.id, ts, PLAYBACKSEGMENTS)

        self.class.to_m3u8(segments, false)
    end

    def self.to_m3u8(segments, live=true)
        seq = segments.first.try(:seq) || 0
        max_duration = segments.map{ |e| e.duration }.max.try(:floor) || 0
        erb = live ? Media::Segment.live_m3u8_tmpl_erb : Media::Segment.play_back_m3u8_tmpl_erb
        erb.result(binding).gsub("\n\n", "\n")
    end
end
