class StaticController < ApplicationController

    def profile
        profile = helpers.get_stock_profile(params[:symbol])
        render json: profile
    end

end