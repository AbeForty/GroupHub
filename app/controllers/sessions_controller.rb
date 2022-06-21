class SessionsController < ApplicationController
    def new
        if !current_user
            render "new"
        else
            redirect_to "/dashboard"
        end
    end
    def create
        u = User.find_by(email: params[:Email])
        if u && u.authenticate(params[:Password])
            o = Organization.find_by(users_id:u.id)
            session[:organization_id] = o.id
            session[:user_id] = u.id
            redirect_to '/dashboard'
        else
            flash[:errors] = ['Invalid Login']
            redirect_to '/'
        end
    end
    def destroy
        session[:user_id] = nil
        redirect_to '/'
    end
end