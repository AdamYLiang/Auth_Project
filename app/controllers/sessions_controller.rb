class SessionsController < ApplicationController

    def new 
        render :new
    end

    def create
        username = params[:user][:username]
        password = params[:user][:password]
        @user = User.find_by_credentials(username, password)
        if @user 
            session[:session] = @user.reset_session_token!
            redirect_to cats_url
        else
            flash.now[:errors] = ["User not found"]
            render :new
        end
    end

    def destroy
        if current_user
            current_user.reset_session_token!
            @current_user = nil
            session[:session] = nil
            render :new
        else
            flash.now[:errors] = ["User not found"]
            render :new
        end
    end
end