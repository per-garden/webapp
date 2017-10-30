Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  root to: 'home#index'
  get 'index.html' => 'home#precache'
  get 'login' => 'login#index'
  namespace :api, defaults: {format: 'json'} do
    post 'login' => 'sessions#login'
    get 'hubs' => 'hubs#index'
    get 'hubs/:id' => 'hubs#show'
    get 'logout' => 'sessions#logout'
  end
end
