Mdc::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :feedbacks, only: [:create]

  match "/error_404" => "errors#not_found"
  match "/error_500" => "errors#server_error"


  get "/buses_images.png" => "buses_images_generator#show", format: 'png'
  #get "/wipe_buses_images" => "buses_images_generator#destroy"

  resources :sell_locations_suggestions, only: [:create]



  match "css_sandbox" => "sandboxes#css"
  match "js_sandbox"  => "sandboxes#js"

  resources :cities, only: [:show], path: "/" do
    collection do
      get "ciudades" => "cities#index", as: ''
    end

    member do
      get "qps" => "cities#show_data", as: :show_data
      get "puntos-de-carga" => "cities#show", sell_locations: true, as: :sell_locations
      get "puntos-de-venta" => "cities#show", sell_locations: true, ticket_locations: true, as: :ticket_locations
      get "(/origen/:origin)(/destino/:destination)" => "cities#show", as: :directions
      get "(/colectivos/:buses)" => "cities#show", as: :buses
    end
  end

  root to: 'cities#redirect_to_default'

  match "*a" => "errors#not_found"
end