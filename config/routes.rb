Sentinel::Application.routes.draw do
  resources :users

  match 'lock' => 'main#lock', :as => :lock
  match 'unlock' => 'main#unlock', :as => :unlock
  match 'delayed_unlock' => 'main#delayed_unlock', :as => :delayed_unlock
  match 'whitelist' => 'main#whitelist', :as => :whitelist

  root :to => 'main#index'
  get "main/index"
end
