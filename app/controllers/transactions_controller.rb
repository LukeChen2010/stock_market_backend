class TransactionsController < ApplicationController

    def index
        user = User.find_by(id: params[:id])
        transactions = user.transactions
        render json: transactions
    end

    def new
        id = params[:id]
        symbol = params[:symbol]
        total_shares = params[:total_shares]

        if total_shares < 0
            render json: {message: "input_error"}
            return
        end

        total_price = helpers.get_stock_quote(symbol)[:current_price] * total_shares

        is_sell = params[:is_sell]

        user = User.find_by(id: id) 

        if is_sell
            owned_stock = helpers.get_stocks(id).find {|x| x[:symbol] == symbol}

            #Prevent the user from selling stocks that they do not currently own
            if !owned_stock || owned_stock[:total_shares] < total_shares
                render json: {message: "insufficient_shares"}
            else
            #Perform the transaction
                stock = user.transactions.create(symbol: symbol, total_shares: total_shares, total_price: total_price, is_sell: is_sell)
                user.balance += total_price
                user.save
                render json: stock
            end
        else
            #Prevent the user from spending more than what they currently have in their balance
            if user.balance < total_price
                render json: {message: "insufficient_balance"}
            else
            #Perform the transaction
                stock = user.transactions.create(symbol: symbol, total_shares: total_shares, total_price: total_price, is_sell: is_sell)
                user.balance -= total_price
                user.save
                render json: stock
            end
        end
    end
 
end