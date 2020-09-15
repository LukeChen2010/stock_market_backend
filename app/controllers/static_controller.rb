class StaticController < ApplicationController

    def stock_quote
        render json: {symbol: params[:symbol], price: "test"}
    end

end