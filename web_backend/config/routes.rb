Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations], controllers: {sessions: 'users/sessions'}
  root to: 'home#index'
  get 'index.html' => 'home#precache'
  namespace :api, defaults: {format: 'json'} do
    get 'hubs' => 'hubs#index'
    get 'hubs/:id' => 'hubs#show'
    get 'logout' => 'sessions#logout'
  end
end
