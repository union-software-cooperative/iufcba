class People::InvitationsController < Devise::InvitationsController
  
  def update
    response = super
    if resource.errors.empty?
      resource.follow!(resource.union)
    end
    return response
  end

  private

  def after_invite_path_for(resource)
    edit_person_path @invitee
  end

  def after_accept_path_for(current_person)
    edit_person_path current_person
  end

  def invite_resource
    @invitee = resource_class.invite!(invite_params, current_inviter) do |u|
      # u.errors.add(:union, "cannot be changed.") unless can_edit_union?(u.union) # Remarked because authorization is now done in person model's validation 
    end
  end

  def invite_params
   	result = params.permit(person: [:authorizer, :gender, :email,:invitation_token, :union_id, :first_name, :last_name,  :title, :address, :mobile, :fax
])[:person].merge(authorizer: current_person)
    result
   end
end