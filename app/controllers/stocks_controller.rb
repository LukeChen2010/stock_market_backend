class StocksController < ApplicationController

    def index
        user = User.find_by(id: params[:id])
        unique_stock_symbols = user.transactions.uniq {|x| x.symbol}.pluck(:symbol)
        unique_stocks = []

        unique_stock_symbols.each do |stock|
            unique_stock_transactions = user.transactions.where(symbol: stock)
            total_shares = 0
            total_price = 0

            unique_stock_transactions.each do |transaction|
                if transaction.is_sell
                    total_shares = total_shares - transaction.total_shares
                    total_price = total_price - transaction.total_price
                else
                    total_shares = total_shares + transaction.total_shares
                    total_price = total_price + transaction.total_price
                end
            end

            unique_stock = {symbol: stock, total_shares: total_shares, total_price: total_price}
            unique_stocks.push(unique_stock)
        end

        render json: unique_stocks
    end

end