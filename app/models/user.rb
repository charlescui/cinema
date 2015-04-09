class User < ActiveRecord::Base
    acts_as_authentic do |c|
      c.crypto_provider = Authlogic::CryptoProviders::Sha512
    end

    has_many :eyes, :class_name => "eye", :through => :user_eye_ships
    has_many :user_eye_ships, :class_name => "user_eye_ship"
end
