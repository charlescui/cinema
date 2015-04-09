class UserEyeShip < ActiveRecord::Base
    belongs_to :user, :class_name => "User", :foreign_key => "user_id"
    belongs_to :eye, :class_name => "Eye", :foreign_key => "eye_id"
end
