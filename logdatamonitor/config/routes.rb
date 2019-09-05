Rails.application.routes.draw do
  root "hot_catch_apps#index"

  resources :users
  resources :hot_catch_apps do
    member do
      get 'show_nginx_graph', to: "hot_catch_apps#show_nginx_graph"
      get 'show_nginx_statistic', to: "hot_catch_apps#show_nginx_statistic"
      get 'show_server_statistic', to: "hot_catch_apps#show_server_statistic"
      get 'nginx_logs', to: "hot_catch_apps#nginx_logs"
      get 'load_nginx_graph', to: "hot_catch_apps#load_nginx_graph"

      get 'get_ajax_table_main_metric'
      get 'get_ajax_table_network_metric'
      get 'show_server_graph'
      get 'load_network_graph'
      get 'load_main_metric_graph'

      get 'load_rails_graph'
      get 'show_rails_graph'

      get 'show_all_graphs'
      get 'load_all_graphs'
    end
  end

  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
  post 'try_login' => 'user_sessions#create', :as => :try_login
  get 'signup' => 'users#new', :as => :signup
  get 'user_sessions/insufficient_privileges', as: :ip


  post "main_hot_catch_logs", to: "main_hot_catch_logs#create"
end
