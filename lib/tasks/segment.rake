namespace :segment do
    desc "Clear EYEID=xxx expired segments"
    task :clean => :environment do
        raise RuntimeError, "No user id found!" if !(eid = ENV["EYEID"])
        if eid.upcase == 'ALL'
            eyes = Eye.all
        else
            eyes = [Eye.find(eid)]
        end

        if eyes and eyes.is_a?(Array)
            eyes.each { |eye|  
                segments = eye.segments.where("created_at < ?", 1.days.ago.to_s(:db))
                segments.each { |e| e.delete_from_aliyun }
            }
        end
    end
end