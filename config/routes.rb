Mdc::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  #
  #scope "(:city_id)", constraints: lambda{|r| false} do
  #  resources :buses, path: "(:names)", only: :index
  #end
  #
  #scope "/", constraints: lambda{|r| Domain.registered?(r.host)} do
  #  resources :buses,  path: "(:names)", only: :index
  #end

  #resources :cities, path: '/', only: [:show] do
  #
  #end

  #city_routes = lambda do
  #  resources :buses, path: "/", only: :index, defaults: {names: ""}
  #  root to: "buses#index"
  #end
  #
  #defaults city_routes: true do
  #
  #  scope "(:city_id)", constraints: ->(r){false} do
  #    city_routes.call
  #  end
  #
  #  scope ":city_id", constraints: (lambda { |r| not Domain.registered?(r.host) }) do
  #    city_routes.call
  #  end
  #
  #  scope "/", constraints: (lambda { |r| Domain.registered?(r.host) }) do
  #    city_routes.call
  #  end
  #
  #  #resources :buses, path: ":names", only: :index, defaults: {names: ""}
  #end
  
  match "/404" => "errors#not_found"
  #get "/buses_images.png" => "buses_images_generator#show"

  scope '/', defaults: {domain_city: true}, constraints: (lambda { |r| Domain.registered?(r.host)}) do
    get '/'           => 'cities#show'
    get '/:buses'     => 'cities#show'
  end
  
  get '/ciudades'   => 'cities#index'

  get '/:id'        => 'cities#show'
  get '/:id/:buses' => 'cities#show'


  root to: "cities#index", redirect: true
  
  match "*a" => "errors#not_found"
end

# mdp.com/555
# mapas.com/mar-del-plata/555