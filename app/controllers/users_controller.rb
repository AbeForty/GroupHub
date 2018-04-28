class UsersController < ApplicationController
    before_action :require_login, except: [:new, :create, :show]
    before_action :require_correct_user, only: [:edit, :update]
    def index
    end
    def new
    end
    def create
      u = User.new(name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      if u.valid?
        u.save
        flash[:errors] = ['Success!']
        session[:user_id] = u.id
        redirect_to '/dashboard'
      else
        flash[:errors] = u.errors.full_messages
        redirect_to '/'
      end
      # redirect_to '/'
    end
    def show
      @user = User.find_by(id: params[:id])
      @numOfCollabProjects = Member.where(user: @user).count
      @otherprojects = Project.all()
      render 'show'
    end
    def edit
      @user = User.find_by(id: session[:user_id])
      render 'edit'
    end
    def update
      u = User.update(params[:id], name: params[:name], email: params[:email])
      if u.valid?
        u.save
        flash[:messages] = ['Success!']
        redirect_to '/users/' + u.id.to_s
      else
        flash[:messages] = u.errors.full_messages
        redirect_to '/users/' + u.id.to_s + '/edit'
      end
    end
    # def destroy
    #   u = User.find(session[:id])
    #   u.delete
    #   session.clear
    #   redirect_to '/users/new'
    # end
end
