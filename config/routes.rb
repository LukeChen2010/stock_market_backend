Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'users/:id/transactions' => 'transactions#index'
  get 'users/:id/stocks' => 'stocks#index'
  get 'stock_quote/:symbol' => 'static#stock_quote'
end
