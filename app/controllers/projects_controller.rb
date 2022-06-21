class ProjectsController < ApplicationController
    before_action :require_login, except: [:show, :search, :show_search]
    def index
      @projects = Project.where(user: current_user)
      @tasks = Task.where(user:current_user)
      @numOfCollabProjects = Member.where(user:current_user).count
      @otherprojects = Project.all
    end
    def new
      @Organizations = []
      @OrgUsers = OrganizationUser.where(user_id: current_user.id)
      @OrgUsers.each do |orgUser|
        @Organizations.push(Organization.find(orgUser.organization_id))
      end
      @OrgOwner = Organization.where(users_id:current_user.id)
      @OrgOwner.each do |orgOwnerItem| 
        @Organizations.push(orgOwnerItem)
      end
      @visibilityFlags = VisibilityFlag.all
      @users = User.where.not(name: current_user.name)
    end
    def dashboard
      @projects = Project.where(user: current_user)
      @tasks = Task.where('user_id = ? AND status != ?', current_user.id, StatusType.find_by(title:"Complete").id)
      @numOfCollabProjects = Member.where(user:current_user).count
      @otherprojects = Project.all
      render 'dashboard'
    end
    def create
      p = Project.new(title: params[:title], description: params[:description], user:current_user, visibility_flags_id: params[:visibilityFlag], duedate: params[:duedate])
      if p.valid?
        p.save
        if params[:organization] != nil || params[:organization] != "0"
          OrganizationProject.new(project_id: p.id, organization_id:params[:organization])
        end
        if params[:members] != nil
          params[:members].each do |member|
            m = Member.new(user: User.find(member), project: p)
            if m.valid?
              m.save        
            else
              flash[:errors] = m.errors.full_messages
              redirect_to '/projects/new'
            end
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
        # @status = StatusType.where(["project_id = :projid OR project_id = :projid2", { projid: nil, projid2: @project.id }])
        # @status = StatusType.where(project_id:@project.id)
        @statusAll = StatusType.where(project_id:nil)
        @status = StatusType.where(project_id:@project.id)
        if (((@project.visibility_flags_id == 3 || @project.visibility_flags_id == 4) and (@project.user_id == current_user.id || @project.users.include?(current_user))) || (@project.visibility_flags_id == 1 || @project.visibility_flags_id == 2 || @project.visibility_flags_id == nil || @project.visibility_flags_id == ''))
          render 'show'
        else
          redirect_to '/dashboard'
        end
      else
        @projects = Project.where(visibility_flags_id: ["", nil, 1])
        # @projects = Project.where("visibility_flags_id = ? or visibility_flags_id = ?", 'null', "1")
        render 'explore'
      end
    end
    def edit
      @Organizations = []
      @OrgUsers = OrganizationUser.where(user_id: current_user.id)
      @OrgUsers.each do |orgUser|
        @Organizations.push(Organization.find(orgUser.organization_id))
      end
      @OrgOwner = Organization.where(users_id:current_user.id)
      @OrgOwner.each do |orgOwnerItem| 
        @Organizations.push(orgOwnerItem)
      end
      @visibilityFlags = VisibilityFlag.all
      @project = Project.find_by(id: params[:id])
      if OrganizationProject.find_by(project_id:params[:id]) != nil
        @projectOrgID = OrganizationProject.find_by(project_id:params[:id]).organization_id
      end
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
      p = Project.update(params[:id], title:params[:title], description:params[:description], visibility_flags_id: params[:visibilityFlag], duedate: params[:duedate])
      if p.valid?
        p.save
        if params[:organization] != nil || params[:organization] != "0"
          if OrganizationProject.where(project_id: p.id).length == 0
            opsave = OrganizationProject.new(project_id: p.id, organization_id:params[:organization])
            if opsave.valid?
              opsave.save
            end
          else
            op = OrganizationProject.find_by(project_id: p.id)
            OrganizationProject.update(op.id, project_id: p.id, organization_id:params[:organization])
          end
        end
        if params[:members]  != nil
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