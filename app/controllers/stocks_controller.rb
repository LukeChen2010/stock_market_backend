class StocksController < ApplicationController

    def index
        unique_stocks = helpers.get_stocks(params[:id])
        render json: unique_stocks
    end

end