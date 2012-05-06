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


  match "/error_404" => "errors#not_found"
  match "/error_500" => "errors#server_error"


  get "/buses_images.png" => "buses_images_generator#show", format: 'png'
  
  scope '/', defaults: {domain_city: true}, constraints: (lambda { |r| r.host.in?(CONFIG[:custom_domains]) }) do
    get '/qps' => 'cities#show_data', format: :qps, as: :show_data_city
    get '/(:buses)' => 'cities#show'
  end

  root to: 'cities#show'

  #scope '/', constraints: (lambda { |r| not Domain.registered?(r.host)}) do
  #  get '/ciudades'   => 'cities#index'
  #  get ':id(:buses)(.:format)' => 'cities#show'
  #  get '/' => 'cities#index', redirect: true
  #end

  #get '/:id(.:format)'        => 'cities#show'
  #get '/:id(/:buses)(.:format)' => 'cities#show'


  #get '/(.:format)', to: "cities#index", redirect: true, as: 'root'
  #get '/(.:format)', to: "cities#show", as: 'root'


  match "*a" => "errors#not_found"
end

# mdp.com/555
# mapas.com/mar-del-plata/555