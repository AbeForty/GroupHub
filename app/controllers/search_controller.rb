class SearchController < ApplicationController
  def search
    session[:return_to] ||= request.referer
    if params[:searchoption] == "Projects"
      @type = "projects"
    elsif params[:searchoption] == "Users"
      @type = "users"
    end
    if params[:search_query]      
      @query = params[:search_query].gsub(/\s+/, "%20")
      puts "Replaced"
      puts @query
      redirect_to '/'+ @type + '/search/' + @query
    elsif params[:search_query] == ""      
      redirect_to session.delete(:return_to)
    # else
    #   @query = params[:search_query].to_s
    #   redirect_to '/'+ @type + '/search/' + @query
    end
  end
  def show_search
    if params[:type] == "projects"
      @search = Project.where('title like ?', '%'+ params[:search_query] + '%')
      @type = "project"
    elsif params[:type] == "users"
      @search = User.where('name like ?', '%'+ params[:search_query] + '%')
      @type = "user"
    end
    puts @search
    @query = params[:search_query]
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