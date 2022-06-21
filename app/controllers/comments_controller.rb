class CommentsController < ApplicationController
    before_action :require_login
    def index      
      @project = Project.find(params[:project_id])
    end
    # def new
    #   @project = Project.find(params[:project_id])
    #   @member = @project.users
    # end
    def create
      c = Comment.new(title: params[:title], comment: params[:comment], user_id: current_user.id, task_id: params[:task_id])
    if c.valid?
        c.save
        puts c.id
        puts params[:attachment]
        @attachment = Attachment.new(attachment: file_params, comment_id: c.id, task_id: c.task_id)
        if @attchment.valid?
          redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s
        end
        redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s
    else
      flash[:errors] = [t.errors.full_messages]
      redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s
    end
      # if params[:attachments] != nil && params[:attachments].length > 0
      #   params[:attachments].each do |attachment|
      #     a = Attachment.new(file: attachment, comment_id:c.id)
      #     if a.valid?
      #       a.save
      #       redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s
      #     else
      #       flash[:errors] = [t.errors.full_messages]
      #       redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s
      #     end
      #   end
      # end
 
      # redirect_to '/'
    end
    # def show
    #   @project = Project.find_by(id: params[:project_id])
    #   @comment = Comment.find_by(id: params[:id])
    #   # redirect_to: request.referrer
    # end
    def edit
      puts params
      @project = Project.find_by(id: params[:project_id])
      @member = @project.users
      @comment = Comment.find_by(id: params[:id])
      # redirect_to: request.referrer
    end
    def update
      c = Comment.update(title: params[:title], comment: params[:comment], user_id: current_user.id, task_id: params[:task_id])
      if c.valid?
        c.save
        flash[:messages] = ['Success!']
        redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s
      else
        flash[:messages] = [c.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s + params[:id].to_s + '/edit'
      end
    end
    def destroy
      c = c.find(params[:id])
      c.delete
      redirect_to '/projects/' + params[:project_id].to_s + '/tasks/' + params[:task_id].to_s
    end
    private
    def file_params
      params.require(:attachment).permit(:attachment)
    end
end
