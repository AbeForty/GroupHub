class ProjectsController < ApplicationController
    before_action :require_login, except: [:show, :search, :show_search]
    def index
      @projects = Project.where(user: current_user)
    end
    def new
      @users = User.where.not(name: current_user.name)
    end
    def dashboard
      @projects = Project.where(user: current_user)
      @tasks = Task.where(user:current_user)
      @numOfCollabProjects = Member.where(user:current_user).count
      @otherprojects = Project.all
      render 'dashboard'
    end
    def create
      p = Project.new(title: params[:title], description: params[:description], user:current_user)
      if p.valid?
        p.save
        params[:members].each do |member|
          m = Member.new(user: User.find(member), project: p)
          if m.valid?
            m.save        
          else
            flash[:errors] = m.errors.full_messages
            redirect_to '/projects/new'
          end
        end     
        redirect_to '/projects/'+ p.id.to_s
        # m = Member
        # flash[:errors] = ['Success!']
        # session[:user_id] = u.id
      else
        flash[:errors] = p.errors.full_messages
        redirect_to '/projects/new'
      end
      # redirect_to '/'
    end
    def join
      session[:return_to] ||= request.referer
      j = Waitinglist.create(user: current_user, project: Project.find(params[:project_id]))
      redirect_to session.delete(:return_to)
    end
    def accept
      session[:return_to] ||= request.referer
      @project = Project.find(params[:project_id])
      if current_user == @project.user 
        j = Waitinglist.find_by(user: User.find(params[:user_id]), project: @project)
        j.destroy
        m = Member.create(user: User.find(params[:user_id]), project: @project)
      end
      redirect_to session.delete(:return_to)
    end
    def decline
      session[:return_to] ||= request.referer
      @project = Project.find(params[:project_id])
      if current_user == @project.user 
        j = Waitinglist.find_by(user: User.find(params[:user_id]), project: Project.find(params[:project_id]))
        j.destroy
      end
      redirect_to session.delete(:return_to)
    end
    def show
      if params[:id].to_s != "all"
        @project = Project.find_by(id: params[:id])
        render 'show'
      else 
        @projects = Project.all
        render 'explore'
      end
    end
    def edit
      @project = Project.find_by(id: params[:id])
      if current_user == @project.user
        @users = User.where.not(id: @project.user.id)
        # @projectusers.each do |member|
        #   puts member.user.name
        # end
        render 'edit'
      else
        redirect_to "/projects/" + @project.id.to_s
      end
    end
    def update
      p = Project.update(params[:id], title:params[:title], description:params[:description])
      if p.valid?
        p.save
        p.members.each do |member|
          if params[:members].include?member
          else
            member.destroy
          end
        end
        params[:members].each do |member|
          if Member.where(user: member, project:p).length == 0 && member != p.user.id
            puts "Member: " + member.to_s
            puts "Owner: " + p.user.id.to_s
            m = Member.new(user: User.find(member), project: p)
            if m.valid?
              m.save
            else
              flash[:errors] = m.errors.full_messages
              redirect_to '/projects/' + p.id.to_s + '/edit'
            end
          end         
        end
          redirect_to '/projects/' + p.id.to_s         
      else
        flash[:messages] = p.errors.full_messages
        redirect_to '/projects/' + p.id.to_s + '/edit'
      end
    end
    def destroy
      p = Projects.find(params[:id])
      p.delete
      redirect_to '/projects'
    end
end
