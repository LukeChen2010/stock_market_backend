class UsersController < ApplicationController

    def show
        user = User.find_by(id: params[:id])

        stocks = helpers.get_stocks(user.id)
        portfolio_value = user.balance.to_f

        stocks.each do |x|
            portfolio_value += x[:current_price] * x[:total_shares]
        end

        render json: JSON.parse(user.to_json).merge({portfolio_value: portfolio_value.round(2).to_s})
    end
 
end