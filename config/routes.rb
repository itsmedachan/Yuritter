Rails.application.routes.draw do
  post 'relationships/:id/create' => "relationships#create"
  post 'relationships/:id/destroy' => "relationships#destroy"

  post 'likes/:post_id/create' => "likes#create"
  post 'likes/:post_id/destroy' => "likes#destroy"

  get '/signup', to:'users#new'
  #get 'signup' => "users#new"
  post '/signup', to:'users#create'

  get '/login', to:'sessions#new'
  #get 'login' => "users#login_form"
  post '/login', to:'sessions#create'
  #post 'login' => "users#login"
  delete '/logout', to:'sessions#destroy'
  #post 'logout' => "users#logout"

  resources :users
  #get 'users/index' => "users#index"
  #post 'users/create' => "users#create"
  #get 'users/:id' => "users#show"
  #get 'users/:id/edit' => "users#edit"
  #post 'users/:id/update' => "users#update"
  get 'users/:id/likes' => "users#likes"
  #get 'users/:id/following' => "users#following"

  get 'posts/index' => "posts#index"
  get 'posts/new' => "posts#new"
  get 'posts/:id' => "posts#show"
  post 'posts/create' => "posts#create"
  get 'posts/:id/edit' => "posts#edit"
  post 'posts/:id/update' => "posts#update"
  post 'posts/:id/destroy' => "posts#destroy"

  root 'home#top'
  #get '/' => "home#top"

  get '/about', to:'home#about'#, as:'about'
  #get 'about', to:'home#about'
  #get '/about' => 'home#about'
  #get 'about' => "home#about"
  #get "about" => "home#about"



  # resources :users do
  #   member do
  #    get :following, :followers
  #    end
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
