require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe People::InvitationsController do
  
  before(:all) do
    @division = FactoryGirl.create(:division)
    #@union = FactoryGirl.create(:union)
    #@owner_union = owner_union
    #@company = FactoryGirl.create(:company)
    #@admin = admin
  end
  
  after(:all) do
    @division.destroy
  end

  # This should return the minimal set of attributes required to create a valid
  # Rec. As you add validations to Rec, be sure to
  # adjust the attributes here as well.
  let(:insider_attributes) { FactoryGirl.attributes_for(:person, union_id: subject.current_person.union.id ) }  
  let(:outsider_attributes) { FactoryGirl.attributes_for(:person, union_id: FactoryGirl.create(:union).id ) } 
  let(:invalid_attributes) { FactoryGirl.attributes_for(:person, email: "") } 
  
  describe "Security" do
    describe "Low privilege access" do
      login_person

      describe "POST create" do
        it "won't allow invitation to other union" do
          post :create, {:person => outsider_attributes}
          expect(assigns(:person).errors.count).to eq(1)
          expect(assigns(:person).errors[:authorizer]).to include('cannot assign a person to a union other than their own.')
          expect(response).to render_template("new")
        end

        it "will allow invitation to my union" do
          post :create, {:person => insider_attributes, division_id: @division.id}
          expect(assigns(:person).errors.count).to eq(0)
          expect(response).to render_template("devise/mailer/invitation_instructions")
          expect(response).to redirect_to(edit_profile_path(assigns(:person)))
        end
      end

    end
  end

  describe "Basic Functionality" do 

    login_admin

    describe "GET new" do
      it "assigns a new person as @person" do
        get :new, {}
        expect(assigns(:person)).to be_a_new(Person)
      end
    end

    describe "POST create" do
      it "creates a new Person" do
        expect {
          post :create, {:person => outsider_attributes}
        }.to change(Person, :count).by(1)
      end

      it "assigns a newly created Person as @person" do
        post :create, {:person => outsider_attributes}
        expect(assigns(:person)).to be_a(Person)
        expect(assigns(:person)).to be_persisted
      end

      it "redirects to the created person" do
        post :create, {:person => outsider_attributes}
        expect(response).to redirect_to(edit_profile_path(assigns(:person)))
      end
      
      describe "with invalid params" do
        it "assigns a newly created but unsaved rec as @rec" do
          # Trigger the behavior that occurs when invalid params are submitted
          post :create, {:person => invalid_attributes}
          expect(assigns(:person)).to be_a_new(Person)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          post :create, {:person => invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end


  end


  describe "PUT Update" do
    before(:each) do
      @admin = admin
    end

    it "person can accept invitation" do
      invitee = FactoryGirl.create(:person, authorizer: admin)
      invitee.invite! admin
      @request.env["devise.mapping"] = Devise.mappings[:person]
      put :update, { person: { id: invitee.id, invitation_token: invitee.raw_invitation_token, password: 'asdfasdf', password_confirmation: 'asdfasdf' } }
      invitee.reload
      expect(invitee.invitation_accepted_at).not_to be_nil
    end

    it "person can't accept invitation if their inviter becomes invalid" do
      invitee = FactoryGirl.create(:person, authorizer: @admin)
      invitee.invite! @admin

      # remove invite privileges from inviter, by moving them to a different union
      @admin.update!(union: FactoryGirl.create(:union), authorizer: FactoryGirl.create(:admin, authorizer: @admin))

      @request.env["devise.mapping"] = Devise.mappings[:person]
      put :update, { person: { id: invitee.id, invitation_token: invitee.raw_invitation_token, password: 'asdfasdf', password_confirmation: 'asdfasdf' } }
      invitee.reload
      expect(invitee.invitation_accepted_at).to be_nil
    end

    it "upon accepting an invitation, user will be following their union" do
      invitee = FactoryGirl.create(:person, union: @admin.union, authorizer: @admin)
      invitee.invite! @admin
      
      #agreement = FactoryGirl.create(:agreement, union_id: invitee.union_id, authorizer: @admin)
      
      @request.env["devise.mapping"] = Devise.mappings[:person]
      put :update, { person: { id: invitee.id, invitation_token: invitee.raw_invitation_token, password: 'asdfasdf', password_confirmation: 'asdfasdf' } }
      
      expect(invitee.union.followers(Person)).to include(invitee)
      #agreement.followers(Person).should include(invitee)
    end
  end
end
