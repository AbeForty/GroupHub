class MilestonesController < ApplicationController
    before_action :require_login
    def index      
      @project = Project.find(params[:project_id])
    end
    def new
      @project = Project.find(params[:project_id])
      @member = @project.users
    end
    def create
      m = Milestone.new(title: params[:title], description: params[:description], duedate: params[:duedate], project_id: params[:project_id], status: 1)
      if m.valid?
        m.save
        redirect_to '/projects/' + params[:project_id].to_s + '/milestones/' + m.id.to_s
      else
        flash[:errors] = [t.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/milestones/' + m.id.to_s
      end
      # redirect_to '/'
    end
    def show
      @project = Project.find_by(id: params[:project_id])
      if @project.users.include? User.find_by(id: session[:user_id]) or @project.user == User.find_by(id: session[:user_id])
      else
        return redirect_to '/dashboard'
      end
      @milestone = Milestone.find_by(id: params[:milestone_id])
      @statusAll = StatusType.where(project_id:nil)
      @status = StatusType.where(project_id:@project.id)
      @tasksCompleted = Task.where('status = ? AND milestone_id = ?', 6, @milestone.id)
      @numberOftasksCompleted = @tasksCompleted.length
      @milestoneTasks = Task.where(milestone_id: @milestone.id)
      @numberOfTasks = @milestoneTasks.length
      if @numberOfTasks != 0
        @percent = ((@numberOftasksCompleted / @numberOfTasks.to_f) * 100).round(2)
      else
        @percent = 0
      end
      render 'show'
    end
    def open
      @project = Project.find_by(id: params[:project_id])
      @milestone = Milestone.find_by(id: params[:milestone_id])
      @milestone.status = 1
      @milestone.save
      redirect_to '/projects/' + params[:project_id].to_s + '/milestones/' + params[:milestone_id].to_s
    end
    def close
      @project = Project.find_by(id: params[:project_id])
      @milestone = Milestone.find_by(id: params[:milestone_id])
      @milestone.status = 0
      @milestone.save
      redirect_to '/projects/' + params[:project_id].to_s + '/milestones/' + params[:milestone_id].to_s
    end
    def edit
      @project = Project.find_by(id: params[:project_id])
      puts 'hi'
      puts @project.members
      if !@project.members.include? User.find_by(id: session[:user_id]) and !@project.user == User.find_by(id: session[:user_id])
        redirect_to '/'
        return
      end
      puts params
      @milestone = Milestone.find_by(id: params[:milestone_id])
      render 'edit'
    end
    def update
      m = Milestone.update(params[:milestone_id], title: params[:title], description: params[:description], duedate: params[:duedate], status: params[:status])
      if m.valid?
        m.save
        flash[:messages] = ['Success!']
        redirect_to '/projects/' + params[:project_id].to_s + '/milestones/' + params[:id].to_s
      else
        flash[:messages] = [m.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/milestones/'
      end
    end
    def destroy
      t = t.find(params[:id])
      t.delete
      redirect_to '/projects/' + params[:project_id].to_s + '/milestones/' + params[:id].to_s
    end
end
