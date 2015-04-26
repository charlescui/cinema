Api::Engine.routes.draw do
    namespace :v1 do
        # eye
        post "/eye/register" => "eye#register"
        get "/eye/live" => "eye#live"
        get "/eye/live.m3u8" => "eye#live"
        get "/eye/play_back" => "eye#play_back"
        get "/eye/play_back.m3u8" => "eye#play_back"

        # segment
        post "/segment" => "segment#create"
        get "/segment" => "segment#index"

        # user
        post "/user/bind" => "user#bind"
    end
end
