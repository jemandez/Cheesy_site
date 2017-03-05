Rails.application.routes.draw do
  devise_for :admins, controllers: { registrations: "registrations"}
  resources :collections, path: 'portafolio' do
    resources :photos
  end

  resources :events, path: 'eventos'
  
  get '/paquetes', to: "pages#paquetes"
  get '/conoceme', to: "pages#conoceme"
  get '/contacto', to: "pages#contacto"

  resources :schools, path: 'escuelas'
  resources :events, path: 'generaciones'
  root "pages#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
