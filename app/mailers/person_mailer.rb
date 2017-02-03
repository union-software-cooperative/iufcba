class PersonMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def rec_notice(person, rec, division)
    @person = person
    @rec = rec
    @division = division
    mail(from: no_reply, to: person.email, subject: "#{rec.person.display_name} has posted an agreement.")
  end

  def post_notice(person, post, division)
    @person = person
    @post = post
    @division = division
    mail(from: no_reply, to: person.email, subject: "#{post.person.display_name} has posted a message.")
  end

  def comment_notice(person, comment, division)
    @person = person
    @comment = comment
    @division = division
    mail(from: no_reply, to: person.email, subject: "#{comment.person.display_name} has left a comment.")
  end

  def thanks(person, rec, division, recipients)
    @person = person
    @rec = rec
    @division = division
    @recipients = recipients
    mail(from: no_reply, to: person.email, subject: "Thanks for sharing an agreement")
  end

  def message_notice(person, message, url, from_email)
    @person = person
    @message = message
    @url = url
    mail(from: from_email, to: person.email, subject: "#{message.person.display_name} is chatting")
  end

  def private_email(to, from, subject, body, request)
    @body = body
    mail(from: from.email, to: to.email, bcc: from.email, subject: subject)
  end

private
  def no_reply
    "noreply@#{ENV['mailgun_host']}"
  end
end
