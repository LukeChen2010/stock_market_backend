class TransactionsController < ApplicationController

    def index
        user = User.find_by(id: params[:id])
        transactions = user.transactions
        render json: transactions
    end

end