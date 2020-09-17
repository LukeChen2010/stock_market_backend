class UsersController < ApplicationController

    #I will have a User model so that I can persist the user's balance
    #My front-end will not have any login/logout/signup functionality
    #That would require a front-end framework to handle cookies and sessions
    #The project directions explicitly say to use one HTML file to render a React/Redux app
    #Therefore, I am leaving out login/logout/signup functionality
    #Still, if I ever wanted to add this functionality down the road, my back-end is already set up for that

    def index
        users = User.all
        render json: users
    end

    def show
        user = User.find_by(id: params[:id])
        render json: user
    end
 
end