class TasksController < ApplicationController
    before_action :require_login
    def index      
      @project = Project.find(params[:project_id])
    end
    def new
      @project = Project.find(params[:project_id])
      @member = @project.users
    end
    def create
      t = Task.new(title: params[:title], description: params[:description], user: User.find(params[:owner]), status: params[:status], duedate: params[:duedate], project: Project.find(params[:project_id]))
      if t.valid?
        t.save
        redirect_to '/projects/'+ params[:project_id].to_s + '/tasks'
      else
        flash[:errors] = [t.errors.full_messages]
        redirect_to '/sessions/new'
      end
      # redirect_to '/'
    end
    def show
      @project = Project.find_by(id: params[:project_id])
      @task = Task.find_by(id: params[:id])
      render 'show'
    end
    def edit
      puts params
      @project = Project.find_by(id: params[:project_id])
      @member = @project.users
      @task = Task.find_by(id: params[:id])
      render 'edit'
    end
    def updateStatus
      session[:return_to] ||= request.referer
      t = Task.update(params[:id], status:params[:status])
      redirect_to session.delete(:return_to)
    end
    def update
      t = Task.update(params[:id], title:params[:title], description:params[:description], status: params[:status], duedate: params[:duedate], user:User.find(params[:owner]))
      if t.valid?
        t.save
        flash[:messages] = ['Success!']
        redirect_to '/projects/' + params[:project_id].to_s
      else
        flash[:messages] = [t.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s + '/edit'
      end
    end
    def destroy
      t = t.find(params[:id])
      t.delete
      redirect_to '/projects/' + params[:project_id].to_s + '/tasks'
    end
end
