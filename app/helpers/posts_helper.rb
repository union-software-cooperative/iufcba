module PostsHelper
  # TODO I18n integration may require breaking up this string.
  def notification_indicator(post)
    result = ""
    assignee_id = nil

    if post.parent.respond_to?(:person) && post.parent.person.present?
      assignee = post.parent.person 
      assignee_id = assignee.id
      result += "#{assignee.display_name} is assigned with "
    end 

    #other_followers = post.parent.followers(Person).reject{|f| f.id == current_person.id || f.id == assignee_id}
    result += "#{pluralize(post.parent.followers(Person).count, "person")} following..."

    result
  end
end
