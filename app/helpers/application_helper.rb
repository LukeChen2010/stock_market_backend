module ApplicationHelper

    #This helper iterates through all the Transactions belonging to the user and consolidates them to get the total shares owned of each stock
    #This function is wrapped in its own helper because there are two controller actions that need this helper:
    #1. get 'users/:id/stocks' => 'stocks#index' This controller action displays a tally of all stocks that the user currently owns
    #2. post 'users/:id/transactions/new' => 'transactions#new' This controller action needs to know how many shares the user currently owns so the user cannot sell stocks which they do not own

    def get_stocks(user_id)
        #This algorithm is pretty brute-force, lots of looping, but it works
        #There might be a more elegant way to do it by using a collection processing method (like map for example?)

        user = User.find_by(id: user_id)
        unique_stock_symbols = user.transactions.uniq {|x| x.symbol}.pluck(:symbol)
        unique_stocks = []

        unique_stock_symbols.each do |symbol|
            unique_stock_transactions = user.transactions.where(symbol: symbol)
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

            unique_stock = {symbol: symbol, total_shares: total_shares, total_price: total_price}
            unique_stocks.push(unique_stock)
        end

        return unique_stocks
    end

    #This method will call the Finnhub API to get live stock prices
    def stock_quote(symbol)
        
    end

end
