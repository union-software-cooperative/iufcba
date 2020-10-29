module ControllerHelpers
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:person]
      person = admin
      sign_in person, scope: :person # sign_in(resource, scope: resource)
    end
  end

  def login_person
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:person]
      person = FactoryGirl.create(:authorized_person)
      sign_in person, scope: :person
    end
  end
end
