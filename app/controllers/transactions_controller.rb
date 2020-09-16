class TransactionsController < ApplicationController

    def index
        user = User.find_by(id: params[:id])
        transactions = user.transactions
        render json: transactions
    end

    def new
        puts "test"

        user_id = params[:user_id]
        symbol = params[:symbol]
        total_shares = params[:total_shares]
        total_price = params[:total_price]
        is_sell = params[:is_sell]

        puts user_id
        puts symbol
        puts total_shares
        puts total_price
        puts is_sell

        user = User.find_by(id: params[:user_id]) 

        stock = Transaction.create(user_id: user_id, symbol: symbol, total_shares: total_shares, total_price: total_price, is_sell: is_sell)

        render json: stock

        if is_sell

        else

        end
    end

end