Migration::Application.routes.draw do
  resources :migration, :only => [:index,:create]
  root :to => 'migration#index'
end