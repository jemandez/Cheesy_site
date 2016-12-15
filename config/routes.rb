Rails.application.routes.draw do
  resources :photos

  get '/paquetes', to: "pages#paquetes"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
