Rails.application.routes.draw do

  mount Wx::Engine => "/wx"
end
