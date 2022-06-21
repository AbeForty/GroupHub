class SearchController < ApplicationController
  def search
    session[:return_to] ||= request.referer
    # if params[:searchoption] == "Projects"
    #   @type = "projects"
    # elsif params[:searchoption] == "Users"
    #   @type = "users"
    # end
    if params[:search_query]      
      @query = params[:search_query].gsub(/\s+/, "%20")
      @query = @query.gsub("/","%2f")
      puts "Replaced"
      puts @query
      redirect_to '/search/' + @query
    elsif params[:search_query] == ""      
      redirect_to session.delete(:return_to)
    # else
    #   @query = params[:search_query].to_s
    #   redirect_to '/'+ @type + '/search/' + @query
    end
  end
  def show_search
    @query = params[:search_query].split(":")[1]
    @memberProjects = []
    @search = []
    Project.all.each do |project|
     if project.users.include?(current_user) || project.user_id == current_user.id
        @memberProjects.push(project)
     end
    end
    if !params[:search_query].include? ":"
      # @userSearch =  User.where('name like ?', '%'+ @query + '%')
      # @projectSearch = Project.where('title like ?', '%'+ @query + '%')
      # @taskSearch = Task.where('title like ?', '%'+ @query + '%')
      # @taskDescriptionSearch = Task.where('description like ?', '%'+ @query + '%')
      # @search = @userSearch.merge(@projectSearch)
    elsif params[:search_query].split(":")[0] == "user"

      @search = User.where('name like ?', '%'+ @query + '%')
      @type = "user"
    elsif params[:search_query].split(":")[0] == "project"
      # @MemberCurrentUser = Member.where(user_id:current_user.id)
      @projectUserMember = []
      @preSearch = []
      @search = []
      # @MemberCurrentUser.each do |memberProject|
      #   @preSearch.push(Project.find_by(id:memberProject.project_id))
      # end
      # @publicProjects = Project.where(visibility_flags_id: ["", nil, 1])
      # @publicProjects.each do |publicProject|
      #   @preSearch.push(publicProject)
      # end
      # @preSearch.each do |finalResult|
      #   if finalResult.title
      #     @preSearch.push(publicProject)
      #   end
      # end
      @preSearch = Project.where('title like ?', '%'+ @query + '%')
      @seenProjectIDs = []
      @found = false
      @preSearch.each do |thisProject|
        puts "Start If"
        if thisProject.visibility_flags_id == 1 || thisProject.visibility_flags_id == nil || thisProject.user_id == current_user.id || Member.where(project_id: thisProject.id, user_id: current_user.id).length > 0
          puts "Seen Project IDs"
          puts @seenProjectIDs
          puts "This Project ID"
          puts thisProject.id
          @seenProjectIDs.each do |currentProjectID|
            if currentProjectID == thisProject.id
              @found = true
              puts @found
            end
          end
          if @found == false
            @search.push(thisProject)
            @seenProjectIDs.push(thisProject.id)
            @found = false
            puts @found
          end
        end        
        @projectUserMember = Member.where(project_id: thisProject.id, user_id: current_user.id)
      end
      # if @projectUserMember != nil
      #   @projectUserMember.each do |finalMember|
      #     @search.each do |currentProject|
      #       if currentProject.id != finalMember.project_id
      #         @search.push(Project.find_by(id:finalMember.project_id))
      #       end
      #     end
      #   end
      # end
      puts "Search Results Loop"
      @search.each do |searchProject|
        puts searchProject.id
      end
      puts @search
      # @search = Project.where(((visibility_flags_id: 3 || visibility_flags_id: 4) and (user_id: current_user.id || users.include?(current_user))) || (visibility_flags_id: 1 || visibility_flags_id: 2 || visibility_flags_id: nil || visibility_flags_id: '')).where('title like ?', '%'+ @query + '%')
      @type = "project"
    elsif params[:search_query].split(":")[0] == "status"
      @memberProjects.each do |mProject|
        mProject.tasks.each do |ptask|
          if StatusType.find(ptask.status).title == @query
            @search.push(ptask)      
          end    
        end
      end
      #@search = Task.where(status: StatusType.find_by(title: @query).id)
      @type = "status"
    elsif params[:search_query].split(":")[0] == "priority"
      @memberProjects.each do |mProject|
        mProject.tasks.each do |ptask|
          if ptask.PriorityType_id != 0
            if PriorityType.find(ptask.PriorityType_id).title == @query
              @search.push(ptask)      
            end
          end
        end
      end
      #@search = Task.where(status: StatusType.find_by(title: @query).id)
      @type = "priority"
    elsif params[:search_query].split(":")[0] == "duedate"
      @duedate = @query.gsub("-","")
      @search = []
      @memberProjects.each do |mProject|
        mProject.tasks.each do |ptask|
          if ptask.duedate == @duedate
            @search.push(ptask)      
          end    
        end
      end  
      # Date.parse(@duedate).strftime("%Y-%m-%d")
      # @search = Task.where(duedate: @query)
      @type = "duedate"
    elsif params[:search_query].split(":")[0] == "datecreated"
      @duedate = @query.gsub("-","")
      # Date.parse(@duedate).strftime("%Y-%m-%d")
      @memberProjects.each do |mProject|
        mProject.tasks.each do |ptask|
          if ptask.created_at == @duedate
            @search.push(ptask)      
          end    
        end
      end  
      # @search = Task.where(created_at: @query)
      @type = "datecreated"
    elsif params[:search_query].split(":")[0] == "dateupdated"
      @duedate = @query.gsub("-","")
      @memberProjects.each do |mProject|
        mProject.tasks.each do |ptask|
          if ptask.updated_at == @duedate
            @search.push(ptask)      
          end    
        end
      end  
      # Date.parse(@duedate).strftime("%Y-%m-%d")
      # @search = Task.where(updated_at: @query)
      @type = "dateupdated"
    elsif params[:search_query].split(":")[0] == "belongsto"
      @search = []
      @memberProjects.each do |mProject|
        mProject.tasks.each do |ptask|
          if ptask.milestone_id == Milestone.find_by(title:@query).id
            @search.push(ptask)      
          end    
        end
      end 
     @type = "milestonetasks" 
    elsif params[:search_query].split(":")[0] == "milestone"
      @search = []
      @memberProjects.each do |mProject|        
          if mProject.id == Milestone.find_by(title:@query).project_id
            @search.push(Milestone.find_by(title:@query))      
          end    
      end  
      #@search = Milestone.where('title like ?', '%'+ @query + '%')
      @type = "milestone"   
    elsif params[:search_query].split(":")[0] == "tag"
      @search = []
      @TTSearch = TagTask.where(Tag.find_by(title:@query).id)
      @TTSearch.each do |tt|
        if @search.include?(Task.find(tt.task_id)) == false
          @search.push(Task.find(tt.task_id))
        end
      end
      @type = "tag"
    elsif params[:search_query].split(":")[0] == "assignedto"
      if @query != "me"
        @owner = User.find_by(name: @query)
      else
        @owner = current_user
        @query = current_user.name
      end
      if @owner != nil
        @initialArr = []
        @initialArr2 = []
        @taskOwner = Task.where(user_id:@owner.id)
        Task.where(user_id:@owner.id).each do |task|
          if task.user_id == current_user.id || Project.find(task.project_id).user_id == current_user.id || Project.find(task.project_id).users.include?(current_user)
            @initialArr.push(task)
          end
        end
        @search = @initialArr
      end
      @type = "assignedto"
    end
    @filter = params[:search_query].split(":")[0]
    render 'search'
  end
end
# def self.replacify *strings, word, repl
#   string =""
#   strings = strings.join(" ").split
#   puts word
#   puts repl
#   strings.each do |s|
#     if s == word
#       s = repl
#       puts s
#     end
#     string +=s +" "
#   end
#   string.strip
# end