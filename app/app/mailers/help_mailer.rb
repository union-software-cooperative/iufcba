class HelpMailer < ApplicationMailer
	add_template_helper(ApplicationHelper)

	def request_invite(person, params, host)
		@person = person
		@params = params
		@query_string = []

		params.each do |k,v|
			@query_string << "#{CGI.escape(k)}=#{CGI.escape(v)}"
		end
		@query_string = "?" + @query_string.join("&")

		mail(from: from(host), to: person.email, subject: "#{params[:first_name]} #{params[:last_name]} (#{params[:affiliate_union]}) is requesting an invite.")
	end

private
	def from(host)
		"noreply@#{host}".gsub("www.", "")
	end
end
