Wx::Engine.routes.draw do
    get '/portal/live' => "portal#live"
    get '/portal/demo' => "portal#demo"
end
