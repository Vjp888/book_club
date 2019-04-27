Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome_page#index'

  get '/books/new', to: 'books#new', as: 'new_book'
  get '/books', to: 'books#index'
  get '/books/:id', to: 'books#show', as: 'book'
  post '/books', to: 'books#create'
  delete '/books/:id', to: 'books#destroy'

  get '/books/:book_id/reviews/new', to: 'reviews#new', as: 'new_book_review'
  post '/books/:book_id/reviews', to: 'reviews#create', as: 'book_reviews'

  # resources :books, only: [:destroy]

  # resources :books, only: [:index, :show, :new, :create, :destroy] do
  #   resources :reviews, only: [:new, :create]
  # end
  # resources :authors, only: [:show, :destroy]
  get '/authors/:id', to: 'authors#show', as: 'author'
  delete '/authors/:id', to: 'authors#destroy'
  # resources :reviews, only: [:show], as: 'user'
  # resources :reviews, only: [:destroy]
  get '/reviews/:id', to: 'reviews#show', as: 'user'
  delete '/reviews/:id', to: 'reviews#destroy', as: 'review'
end
