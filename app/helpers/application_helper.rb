module ApplicationHelper

    #This function is wrapped in its own helper because there are several controller actions that need this helper:
    #1. get 'users/:id => 'stocks#index' Needs data from this helper to calculate portfolio value
    #2. get 'users/:id/stocks' => 'stocks#index' Displays a tally of all stocks that the user currently owns
    #3. post 'users/:id/transactions/new' => 'transactions#new'  Needs data from this helper to know how many shares the user currently owns so the user cannot sell stocks which they do not own
    def get_stocks(user_id)
        user = User.find_by(id: user_id)
        unique_stock_symbols = user.transactions.uniq {|x| x.symbol}.pluck(:symbol)
        unique_stocks = []

        id = 1

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
            daily_change = (current_price - previous_close).round(2)
            current_value = (current_price * total_shares).round(2)
            total_gain_loss = (current_value - total_price).round(2)

            unique_stock = {id: id, symbol: symbol, total_shares: total_shares, total_price: total_price, previous_close: previous_close, current_price: current_price, daily_change: daily_change, current_value: current_value, total_gain_loss: total_gain_loss}
            unique_stocks.push(unique_stock) unless unique_stock[:total_shares] == 0

            id = id + 1
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
