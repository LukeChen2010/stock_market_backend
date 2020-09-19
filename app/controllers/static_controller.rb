class StaticController < ApplicationController

    def stock_quote
        stock_quote = helpers.get_stock_profile(params[:symbol])
        render json: stock_quote
    end

end