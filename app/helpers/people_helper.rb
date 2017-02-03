module PeopleHelper
  def profile_heading 
    if current_person == @person
      t('.my_profile')
    else
      @person.display_name
    end
  end

  def profile_image
    unless @person.attachment.blank?
      image_tag @person.attachment.url, class: "profile_image"
    end
  end
end
