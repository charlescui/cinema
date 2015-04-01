namespace :segment do
    desc "Clear EYEID=xxx expired segments"
    task :clean => [:dependent, :tasks] do
        raise RuntimeError, "No user id found!" if !(eid = ENV["EYEID"])
        eye = Eye.find(eid)
        segments = eye.segments.where("created_at < ?", 1.days.ago.to_s(:db))
        segments.each { |e| e.delete_from_aliyun }
    end
end