class StocksController < ApplicationController

    #There is no Stock model that is associated with StocksController
    #Instead, Stock "objects" are derived from Transaction objects
    #e.g. if a user buys 50 shares of Apple stock and then sells 10 shares, the Stock "object" will show the user owning 40 shares of Apple stock
    #Not the most RESTful way to do it, but it makes the routes look clean: e.g. users/1/stocks
    #I could have chosen to use the front-end to make a call to users/:id/transactions and crunch this data, but I think it makes much more sense to leave it in the back-end
    #This in my opinion is core business logic that is best kept in the back-end

    def index
        #See the get_stocks method under application_helper.rb for algorithm
        unique_stocks = helpers.get_stocks(params[:id])
        render json: unique_stocks
    end

end