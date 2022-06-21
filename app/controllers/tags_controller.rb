class TagsController < ApplicationController
    before_action :require_login
    def index      
      @project = Project.find(params[:project_id])
      @tag = Tag.where(project_id: params[:project_id])
    end
    def new
      @project = Project.find(params[:project_id])
    end
    def create
      s = Tag.new(title: params[:title], project_id:params[:project_id])
      if s.valid?
        s.save
        redirect_to '/projects/' + params[:project_id].to_s + '/tags/' + params[:id].to_s
      else
        flash[:errors] = [t.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/tags/' + params[:id].to_s
      end
      # redirect_to '/'
    end
    def show
      @project = Project.find(params[:project_id])
      @tag = Tag.find_by(id: params[:tag_id])
      render 'show'
    end
    def edit
      puts params
      @project = Project.find(params[:project_id])
      @tag = Tag.find_by(id: params[:tag_id])
      render 'edit'
    end
    def update
      t = Tag.update(title: params[:title], project_id:params[:project_id])
      if t.valid?
        t.save
        flash[:messages] = ['Success!']
        redirect_to '/projects/' + params[:project_id].to_s + '/tags/' + params[:id].to_s
      else
        flash[:messages] = [t.errors.full_messages]
        redirect_to '/projects/' + params[:project_id].to_s + '/tags/' + params[:id].to_s + '/edit'
      end
    end
    def destroy
      t = t.find(params[:id])
      t.delete
      redirect_to '/projects/' + params[:project_id].to_s + '/tags/' + params[:id].to_s
    end
end
