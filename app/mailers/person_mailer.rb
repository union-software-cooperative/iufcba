class PersonMailer < ApplicationMailer
	add_template_helper(ApplicationHelper)

	def rec_notice(person, rec, request)
		@person = person
		@rec = rec
		@request = request
		mail(from: from(request), to: person.email, subject: "#{rec.person.display_name} has posted an agreement.")
	end

	def post_notice(person, post, request)
		@person = person
		@post = post
		@request = request
		mail(from: from(request), to: person.email, subject: "#{post.person.display_name} has posted a message.")
	end

	def comment_notice(person, comment, request)
		@person = person
		@comment = comment
		@request = request
		mail(from: from(request), to: person.email, subject: "#{comment.person.display_name} has left a comment.")
	end

	def thanks(person, rec, request,recipients)
		@person = person
		@rec = rec
		@request = request
		@recipients = recipients
		mail(from: from(request), to: person.email, subject: "Thanks for sharing an agreement")
	end

	def message_notice(person, message, request)
		@person = person
		@message = message
		@request = request
		mail(from: from(request), to: person.email, subject: "#{message.person.display_name} is chatting")
	end

	def private_email(to, from, subject, body, request)
		@body = body
		headers(:bcc) = from.email
		mail(from: from.email, to: to.email, subject: subject)
	end

private
	def from(request)
		"noreply@#{request.host}".gsub("www.", "")
	end
end
