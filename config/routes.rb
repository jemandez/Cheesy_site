Rails.application.routes.draw do
  devise_for :admins, controllers: { registrations: "registrations"}
  resources :groups, path: 'grupos' do
    resources :students
  end
  
  get '/paquetes', to: "pages#paquetes"
  get '/conoceme', to: "pages#conoceme"
  get '/contacto', to: "pages#contacto"

  resources :schools, path: 'escuelas'
  resources :generations, path: 'generaciones'
  resources :students, path: 'alumnos'

  root 'schools#index'
  #root "pages#home"3
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
