class OrganizationController < ApplicationController
  before_action :require_login
    def joinornew
        render 'joinornew'
    end
    def new
        render 'new'
    end
    def show
      @companycode = Companycode.find_by(organizations_id:params[:organization_id])
      @organization = Organization.find(params[:organization_id])
      @orgProjects = OrganizationProject.where(organization_id:params[:organization_id])
      @orgUsers = OrganizationUser.where(organization_id:params[:organization_id])
      @organizationUsers = []
      @organizationProjects = []
      @orgProjects.each do |orgProj|
        proj = Project.find(orgProj.project_id)
        @organizationProjects.push(proj)
      end
      @orgUsers.each do |orgUser|
        user = User.find(orgUser.user_id)
        @organizationUsers.push(user)
      end
      @owner = User.find(@organization.users_id)
      @organizationUsers.push(User.find(@organization.users_id))
      render 'show'
    end
    def edit
      @Organization = Organization.find_by(id: params[:organization_id])
      if current_user == User.find(@Organization.users_id)
        render 'edit'
      else
        redirect_to '/organizations/' + params[:organization_id].to_s
      end
    end
    def numToLetter(passedNumber)
      if passedNumber == 0
        return 'A'
      elsif passedNumber == 1
        return 'B'
      elsif passedNumber == 2
        return 'C'
      elsif passedNumber == 3
        return 'D'
      elsif passedNumber == 4
        return 'E'
      elsif passedNumber == 5
        return 'F'
      elsif passedNumber == 6
        return 'G'
      elsif passedNumber == 7
        return 'H'
      elsif passedNumber == 8
        return 'I'
      elsif passedNumber == 9
        return 'J'
      elsif passedNumber == 10
        return 'K'
      elsif passedNumber == 11
        return 'L'
      elsif passedNumber == 12
        return 'M'
      elsif passedNumber == 13
        return 'N'
      elsif passedNumber == 14
        return 'O'
      elsif passedNumber == 15
        return 'P'
      elsif passedNumber == 16
        return 'Q'
      elsif passedNumber == 17
        return 'R'
      elsif passedNumber == 18
        return 'S'
      elsif passedNumber == 19
        return 'T'
      elsif passedNumber == 20
        return 'U'
      elsif passedNumber == 21
        return 'V'
      elsif passedNumber == 22
        return 'W'
      elsif passedNumber == 23
        return 'X'
      elsif passedNumber == 24
        return 'Y'
      elsif passedNumber == 25
        return 'Z'
      end
    end
    def create
        o = Organization.new(name: params[:title], address: params[:address], city: params[:city], state: params[:state], zipcode: params[:zip], logo: params[:logo], headercolor: params[:headerbkgcolor], headertextcolor: params[:headertextcolor], bodytextcolor: params[:bodytextcolor], users_id: current_user.id)
        if o.valid?
          o.save
          companyCode = ""
          companyCode << numToLetter(rand(26)) << (rand(10)).to_s << (rand(10).to_s << numToLetter(rand(26)) << numToLetter(rand(26)) << (rand(10)).to_s)
          session[:organization_id] = o.id
          flash[:errors] = ['Success!']
          redirect_to '/dashboard'
        else
          flash[:errors] = o.errors.full_messages
          redirect_to '/orgnaizations/new'
        end
        # redirect_to '/'
    end
    def update
        o = Organization.update(params[:organization_id], name: params[:title], address: params[:address], city: params[:city], state: params[:state], zipcode: params[:zip], logo: params[:logo], headercolor: params[:headerbkgcolor], headertextcolor: params[:headertextcolor], bodytextcolor: params[:bodytextcolor], users_id: current_user.id)
          if o.valid?
            o.save
            flash[:messages] = ['Success!']
            redirect_to '/organizations/' + o.id.to_s
          else
            flash[:messages] = u.errors.full_messages
            redirect_to '/organizations/' + o.id.to_s/edit
            # redirect_to request.referer
          end
    end
    def generatecode
      companyCode = ""
      companyCode << numToLetter(rand(26)) << (rand(10)).to_s << (rand(10).to_s << numToLetter(rand(26)) << numToLetter(rand(26)) << (rand(10)).to_s)
      cc = Companycode.new(code: companyCode, organizations_id:params[:organization_id])
      if cc.valid?
        cc.save
      end
      redirect_to '/organizations/' + params[:organization_id].to_s
    end
    # def file_params
    #   params.require(:logo).permit(:logo)
    # end
end
