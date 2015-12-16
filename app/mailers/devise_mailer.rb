class DeviseMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views


	def invitation_instructions(record, token, opts={})
	  #headers["Custom-header"] = "Bar"
	  opts[:subject] = "dairyworker.org invitation"
	  opts[:from] = "#{record.invited_by.display_name} <#{record.invited_by.email}>"
	  opts[:cc] = record.invited_by.email
	  headers[:cc]= record.invited_by.email
	  super
	end
end