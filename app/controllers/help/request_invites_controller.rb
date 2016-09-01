class Help::RequestInvitesController < ApplicationController
	before_action :authenticate_person!, except: [:new, :create]

	def new
	end

	def create
		@errors = []
    @errors << "Please provide an email" if params[:email].blank?
    @errors << "Please provide a first name" if params[:first_name].blank?
    @errors << "Please provide a last name" if params[:last_name].blank?
    @errors << "Please provide a title" if params[:title].blank?
    @errors << "Please provide an affiliate union" if params[:affiliate_union].blank?
    
		if @errors.blank? 
			#owner_union.people.each do |p| 
			#	HelpMailer.request_invite(p, request_invitation_params, request.host).deliver_later     
    	#end
    	if p = Person.find_by_email(ENV['admin_email'])
    		HelpMailer.request_invite(p, request_invitation_params, request.host).deliver_later     
    	end

    	redirect_to "/", notice: "Thanks for your interest.  Your request will be reviewed soon."
    else
    	render "new"
    end	
  end

	def request_invitation_params
		params.slice(:first_name, :last_name, :email, :title, :message, :affiliate_union)
	end
end
