Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  mount Api::Engine => '/api', :as => 'api'
  mount Wx::Engine => '/wx', :as => 'wx'
  mount WxApi::V1::Server => '/wx_api/v1', :as => 'wx_api_v1'

end
