class StatusController < ApplicationController
    before_action :require_login
    def index      
      @project = Project.find(params[:project_id])
      @status = StatusType.where(project_id: params[:project_id])
    end
    def new
      @project = Project.find(params[:project_id])
    end
    def create
      s = StatusType.new(title: params[:title], color: params[:color], project_id:params[:project_id])
      if s.valid?
        s.save
        redirect_to '/projects/' + params[:project_id].to_s + '/status/' + params[:id].to_s
      else
        flash[:errors] = [t.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/status/' + params[:id].to_s
      end
      # redirect_to '/'
    end
    def show
      @project = Project.find(params[:project_id])
      echo params[:status_type_id]
      @status = StatusType.find_by(id: params[:status_type_id])
      render 'show'
    end
    def edit
      puts params
      @project = Project.find(params[:project_id])
      @status = StatusType.find_by(id: params[:status_type_id])
      render 'edit'
    end
    def update
      s = StatusType.update(title: params[:title], color: params[:color], project_id:params[:project_id])
      if s.valid?
        s.save
        flash[:messages] = ['Success!']
        redirect_to '/projects/' + params[:project_id].to_s + '/status/' + params[:id].to_s
      else
        flash[:messages] = [s.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/status/' + params[:id].to_s + '/edit'
      end
    end
    def destroy
      s = s.find(params[:id])
      s.delete
      redirect_to '/projects/' + params[:project_id].to_s + '/status/' + params[:id].to_s
    end
end
