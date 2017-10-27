Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    post 'login' => 'sessions#login'
    get 'hubs' => 'hubs#index'
    get 'hubs/:id' => 'hubs#show'
    get 'logout' => 'sessions#logout'
  end
end
