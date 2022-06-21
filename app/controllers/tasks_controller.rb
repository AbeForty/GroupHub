class TasksController < ApplicationController
    before_action :require_login
    def index      
      @project = Project.find(params[:project_id])
      # @status = StatusType.where(["project_id = :projid OR project_id = :projid2", { projid: nil, projid2: @project.id }]
        # project_id:nil or project_id:@project.id)
      # @status = StatusType.where(project_id:@project.id)
      @statusAll = StatusType.where(project_id:nil)
      @status = StatusType.where(project_id:@project.id)
    end
    def new
      if request.referer != nil
        if request.referer.include? "milestone"
          @milestoneSelected = Milestone.find_by(id:request.referer.split("/")[6])
        end
      end
      @project = Project.find(params[:project_id])
      @milestone = @project.milestones
      @member = @project.users
      @statusAll = StatusType.where(project_id:nil)
      @status = StatusType.where(project_id:@project.id)
      @priorityAll = PriorityType.where(project_id:nil)
      @priority = PriorityType.where(project_id:@project.id)
      @tag = Tag.where(project_id:@project.id)
    end
    def create
      @previousURL = request.referer
      if params[:milestone] != "0"
        if params[:duedate] != nil
          t = Task.new(title: params[:title], description: params[:description],user: User.find(params[:owner]), status: params[:status], PriorityType_id: params[:priority], duedate: params[:duedate], project: Project.find(params[:project_id]), milestone: Milestone.find(params[:milestone]))
        else
          t = Task.new(title: params[:title], description: params[:description],user: User.find(params[:owner]), status: params[:status], PriorityType_id: params[:priority], project: Project.find(params[:project_id]),milestone: Milestone.find(params[:milestone]))
        end
        if params[:tags] != nil
        params[:tags].each do |tag|
          tt = TagTask.create(tag: Tag.find(tag),task: t)
           if tt.valid?
             tt.save
           else
             flash[:errors] = tt.errors.full_messages
             redirect_to '/projects/' + p.id.to_s + '/tasks' + '/create'
           end
         end
        end
      else
        if params[:duedate] != nil
          t = Task.new(title: params[:title], description: params[:description],user: User.find(params[:owner]), status: params[:status], PriorityType_id: params[:priority], duedate: params[:duedate], project: Project.find(params[:project_id]),milestone: Milestone.find(params[:milestone]))
        else
          t = Task.new(title: params[:title], description: params[:description],user: User.find(params[:owner]), status: params[:status], PriorityType_id: params[:priority], project: Project.find(params[:project_id]),milestone: Milestone.find(params[:milestone]))
        end
        if params[:tags] != nil      
        params[:tags].each do |tag|
          tt = TagTask.create(tag: Tag.find(tag),task: t)
           if tt.valid?
             tt.save
           else
             flash[:errors] = m.errors.full_messages
             redirect_to '/projects/' + p.id.to_s + '/tasks/' + params[:id].to_s + '/edit'
           end
         end
        end
      end      
      if t.valid?
        t.save
        redirect_to @previousURL
        # redirect_to '/projects/'+ params[:project_id].to_s + '/tasks/' + params[:task_id].to_s
      else
        flash[:errors] = [t.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/create'
      end
      # redirect_to '/'
    end
    def show
      @attachment = Attachment.new
      @project = Project.find_by(id: params[:project_id])
      # puts @project.user.id
      if @project.users.include? User.find_by(id: session[:user_id]) or @project.user == User.find_by(id: session[:user_id])
      else
        return redirect_to '/dashboard'
      end
      @task = Task.find_by(id: params[:id])
      @comments = @task.comments
      # @status = StatusType.where(["project_id = :projid OR project_id = :projid2", { projid: nil, projid2: @project.id }])
      @statusAll = StatusType.where(project_id:nil)
      @status = StatusType.where(project_id:@project.id)
      if @task.PriorityType_id != nil
        @priority = PriorityType.find_by(id: @task.PriorityType_id)
      else
        @priority = nil
      end
      @tag = Tag.where(project_id:@project.id)
      @previousURL = request.referer
      if @previousURL != nil
        if @previousURL.include? "milestone" and !@previousURL.include? "new" and !@previousURL.include? "edit"
          @returnToName = Milestone.find_by(id:@previousURL.split("/")[6]).title + " milestone"
        elsif @previousURL.include? "milestone" and @previousURL.include? "new"
          @returnToName =  " Create a milestone for " + Project.find_by(id:@previousURL.split("/")[4]).title
        elsif @previousURL.include? "milestone" and @previousURL.include? "edit"
          @returnToName =  " Edit " + Milestone.find_by(id:@previousURL.split("/")[6]).title
        elsif @previousURL.include? "search"
          @returnToName = " search results"
        elsif @previousURL.include? "tasks" and !@previousURL.include? "new" and !@previousURL.include? "edit"
          @returnToName = @project.title + " tasks"
        elsif @previousURL.include? "tasks" and @previousURL.include? "new"
          @returnToName =  " Create a task for " + Project.find_by(id:@previousURL.split("/")[4]).title
        elsif @previousURL.include? "tasks" and @previousURL.include? "edit"
          @returnToName =  " Edit " + Task.find_by(id:@previousURL.split("/")[6]).title
        elsif @previousURL.include? "dashboard"
          @returnToName = " dashboard"
        elsif @previousURL.include? "user"
          @returnToName = User.find_by(id:@previousURL.split("/")[4]).name + "'s profile"
        elsif @previousURL.include? "project" and !@previousURL.include? "new" and !@previousURL.include? "edit"
          puts @previousURL.split("/")
          @returnToName = Project.find_by(id:@previousURL.split("/")[4]).title + " details"
          puts @returnToName
        # elsif @previousURL.include? "project" and !@previousURL.include? "new" and !@previousURL.include? "edit" and !@previousURL.include? "tasks"
        #   puts @previousURL.split("/")
        #   puts params[:project_id]
        #   @returnToName = Project.find_by(id:params[:project_id]) + " details"
        end
      else
        @previousURL = "/dashboard"
        @returnToName = "Dashboard"
      end
      render 'show'
    end
    def edit
      puts params
      @project = Project.find_by(id: params[:project_id])
      @member = @project.users
      @milestone = @project.milestones
      @task = Task.find_by(id: params[:id])
      @statusAll = StatusType.all
      @status = StatusType.where(project_id:@project.id)
      @priorityAll = PriorityType.where(project_id:nil)
      @priority = PriorityType.where(project_id:@project.id)
      @tag = Tag.where(project_id:@project.id)
      @tagtask = TagTask.where(task_id:@task.id)
      puts @tag
      puts @tagtask
      render 'edit'
    end
    def updateStatus
      session[:return_to] ||= request.referer
      t = Task.update(params[:id], status:params[:status])
      redirect_to session.delete(:return_to)
    end
    def update
      if params[:milestone] != "0"
        if params[:duedate] != nil
          t = Task.update(params[:id], title:params[:title], description:params[:description],user: User.find(params[:owner]), status: params[:status], PriorityType_id: params[:priority], duedate: params[:duedate], milestone: Milestone.find(params[:milestone]))
        else
          t = Task.update(params[:id], title:params[:title], description:params[:description],user: User.find(params[:owner]), status: params[:status], PriorityType_id: params[:priority], milestone: Milestone.find(params[:milestone])) 
        end
          if params[:tags] != nil
          params[:tags].each do |tag|
          if TagTask.find_by(task_id: t.id, tag_id: tag) == nil
            tt = TagTask.create(tag: Tag.find(tag),task: t)
            if tt.valid?
              tt.save
            else
              flash[:errors] = m.errors.full_messages
              redirect_to '/projects/' + p.id.to_s + '/tasks/' + params[:id].to_s + '/edit'
            end
          end        
        end
      end
      else
        if params[:duedate] != nil
          t = Task.update(params[:id], title:params[:title], description:params[:description],user: User.find(params[:owner]), status: params[:status], PriorityType_id: params[:priority], duedate: params[:duedate], milestone: Milestone.find(params[:milestone])) 
        else
          t = Task.update(params[:id], title:params[:title], description:params[:description],user: User.find(params[:owner]), status: params[:status], PriorityType_id: params[:priority], milestone: Milestone.find(params[:milestone])) 
        end
        if params[:tags] != nil
        params[:tags].each do |tag|
          if TagTask.find_by(task_id: t.id, tag_id: tag) == nil
            tt = TagTask.create(tag: Tag.find(tag),task: t)
            if tt.valid?
              tt.save
            else
              flash[:errors] = m.errors.full_messages
              redirect_to '/projects/' + p.id.to_s + '/tasks/' + params[:id].to_s + '/edit'
            end
          end
         end
        end
      end
      Tag.all.each do |allTag|
        if params[:tags] != nil
        if params[:tags].include?(allTag.id.to_s) == false
          if TagTask.find_by(tag_id: allTag.id, task_id:t.id) != nil
            TagTask.find_by(tag_id: allTag.id, task_id:t.id).delete
          end
        end
      end
      end
      if t.valid?
        t.save
        flash[:messages] = ['Success!']
        redirect_to '/projects/' + params[:project_id].to_s + "/tasks/" + params[:id].to_s
      else
        flash[:messages] = [t.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:id].to_s + '/edit'
      end
    end
    def destroy
      t = t.find(params[:id])
      t.delete
      redirect_to '/projects/' + params[:project_id].to_s + '/tasks'
    end
end