Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get 'stock_profile/:symbol' => 'static#profile'

  get 'users' => 'users#index'
  get 'users/:id' => 'users#show'
  
  get 'users/:id/transactions' => 'transactions#index'
  post 'users/:id/transactions/new' => 'transactions#new'

  get 'users/:id/stocks' => 'stocks#index'
  get 'stock_quote/:symbol' => 'static#stock_quote'
end
