Rails.application.routes.draw do
  resources :collections
  resources :photos

  get '/paquetes', to: "pages#paquetes"

  root "pages#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
