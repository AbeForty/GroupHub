class UsersController < ApplicationController
    before_action :require_login, except: [:new, :create, :show]
    before_action :require_correct_user, only: [:edit, :update]
    def index
    end
    def new
    end
    def selecttype
      render 'selecttype'
    end
    def create
      u = User.new(name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      if u.valid?
        u.save
        flash[:errors] = ['Success!']
        session[:user_id] = u.id
        redirect_to '/users/selecttype'
      else
        flash[:errors] = u.errors.full_messages
        redirect_to '/'
      end
      # redirect_to '/'
    end
    def show
      @status = StatusType.all
      @user = User.find_by(id: params[:id])
      @hideEmailStatus = @user.hideEmail
      @numOfCollabProjects = Member.where(user: @user).count
      @collabProjects = []
      @currentUser = User.find_by(id: session[:user_id])
      @userProjects = Project.where(["user_id = ? and (visibility_flags_id = ? or visibility_flags_id = ? or visibility_flags_id IS ?)", @user.id, "1", "",nil])
      if @user != @currentUser
        Project.all.each do |project|
          puts project.users
          # if project.users.include? @user || project.users.include? @currentUser
          project.users.each do |member|
              if project.users.include? @user and project.users.include? @currentUser
              # if member.id == @user.id || member.id == session[:user_id] || project.user_id == @user.id || project.user_id == session[:user_id]
                @collabProjects.push(project.id)
              end
          end
        end
      else
      end 
      if @user != @currentUser
        @userTasks = []
      else
        @userTasks = Task.where(user_id: @user.id)
      end
      Task.all.each do |task|
        if @collabProjects.include? task.project_id and task.user == @user
          @userTasks.push(task)
        end
      end
      puts "Collab Projects"
      puts @collabProjects
      puts "User Tasks"
      puts @userTasks
      @otherprojects = Project.all()
      render 'show'
    end
    def edit
      @user = User.find_by(id: session[:user_id])
      @hideEmailStatusInt = @user.hideEmail
      if @hideEmailStatusInt == 0
        @hideEmailStatus = false
      else
        @hideEmailStatus = true
      end
      render 'edit'
    end
    def update
      puts "Params"
      puts params
      @hideEmailInt = nil
      if params[:hideEmail] == "on"
        @hideEmailInt = 1
      else
        @hideEmailInt = 0
      end
      if params[:password] != "" and params[:password_confirmation] != ""
        u = User.update(params[:id], name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], hideEmail: @hideEmailInt)
      else
        u = User.update(params[:id], name: params[:name], email: params[:email], hideEmail: @hideEmailInt)
      end
      if u.valid?
        u.save
        flash[:messages] = ['Success!']
        redirect_to '/users/' + u.id.to_s
      else
        flash[:messages] = u.errors.full_messages
        redirect_to request.referer
      end
    end
    # def destroy
    #   u = User.find(session[:id])
    #   u.delete
    #   session.clear
    #   redirect_to '/users/new'
    # end
end