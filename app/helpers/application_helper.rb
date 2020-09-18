module ApplicationHelper

    #This helper iterates through all the Transactions belonging to the user and consolidates them to get the total shares owned of each stock
    #This function is wrapped in its own helper because there are two controller actions that need this helper:
    #1. get 'users/:id/stocks' => 'stocks#index' This controller action displays a tally of all stocks that the user currently owns
    #2. post 'users/:id/transactions/new' => 'transactions#new' This controller action needs to know how many shares the user currently owns so the user cannot sell stocks which they do not own
    def get_stocks(user_id)
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

            unique_stock_quote = get_stock_quote(symbol)
            previous_close = unique_stock_quote[:previous_close]
            current_price = unique_stock_quote[:current_price]

            unique_stock = {symbol: symbol, total_shares: total_shares, total_price: total_price, previous_close: previous_close, current_price: current_price}
            unique_stocks.push(unique_stock) unless unique_stock[:total_shares] == 0
        end

        return unique_stocks
    end

    def get_stock_profile(symbol)
        stock_profile = get_payload("https://finnhub.io/api/v1/stock/profile2?symbol=#{symbol}&token=brbai0nrh5rb7je2n1l0")
        profile = {}

        if stock_profile == {}
            return {}
        else
            profile[:symbol] = stock_profile["ticker"]
            profile[:name] = stock_profile["name"]
            profile[:exchange] = stock_profile["exchange"]
            profile[:industry] = stock_profile["finnhubIndustry"]
            profile[:weburl] = stock_profile["weburl"]

            stock_quote = get_payload("https://finnhub.io/api/v1/quote?symbol=#{symbol}&token=brbai0nrh5rb7je2n1l0")
            
            profile[:previous_close] = stock_quote["pc"].to_f
            profile[:current_price] = stock_quote["c"].to_f   
        end

        return profile
    end

    def get_stock_quote(symbol)
        stock_quote = get_payload("https://finnhub.io/api/v1/quote?symbol=#{symbol}&token=brbai0nrh5rb7je2n1l0")
        quote = {}

        quote[:previous_close] = stock_quote["pc"].to_f
        quote[:current_price] = stock_quote["c"].to_f  

        return quote
    end

    def get_payload(url)
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        payload = JSON.parse(response.body)
    end

end
