namespace :sample do
    desc "Load Sample Eye data."
    task :eye => [:dependent, :tasks] do
        eye = Eye.new(:login => SecureRandom.hex)
        passwd = SecureRandom.hex[0..15]
        eye.password = eye.password_confirmation = passwd
        eye.save
        eye.reset_single_access_token!
    end

    desc "Load Sample User data."
    task :user => [:dependent, :tasks] do
        user = User.new(:login => SecureRandom.hex)
        passwd = SecureRandom.hex[0..15]
        user.password = user.password_confirmation = passwd
        user.save
    end

    desc "Load Sample Media::Segment data."
    task :user => [:dependent, :tasks] do
        seg = Media::Segment.new
        seg.save
    end
end