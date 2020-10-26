require 'rails_helper'

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

describe RecsController do
  
  before(:all) do
    @division = FactoryGirl.create(:division)
    @union = FactoryGirl.create(:union)
    @owner_union = owner_union
    @company = FactoryGirl.create(:company)
    @admin = admin
  end
  
  after(:all) do
    # [@division, @union, @company].each(&:destroy)
  end

  # This should return the minimal set of attributes required to create a valid
  # Rec. As you add validations to Rec, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for(:agreement, union_id: subject.current_person.union.id, company_id: @company.id, person_id: subject.current_person.id, authorizer: subject.current_person ) } 
  let(:invalid_person) { FactoryGirl.attributes_for(:agreement, union_id: subject.current_person.union.id, company_id: @company.id, person_id: @admin.id, authorizer: subject.current_person ) } 
  let(:invalid_union) { FactoryGirl.attributes_for(:agreement, union_id: @owner_union.id, company_id: @company.id, person_id: subject.current_person.id, authorizer: subject.current_person ) } 

  describe "Security" do
    describe "Low privilege access" do
      login_person

      describe "POST create" do
        it "won't allow assignment to non-colleague" do
          scoped_post :create, {:rec => invalid_person}
          expect(assigns(:rec).errors.count).to eq(1)
          expect(assigns(:rec).errors[:person]).to include('is not a colleague from your union so this assignment is not authorized.')
          expect(response).to render_template("new")
        end
        
        it "won't allow assignment to other union" do
          scoped_post :create, {:rec => invalid_union}
          expect(assigns(:rec).errors.count).to eq(1)
          expect(assigns(:rec).errors[:union]).to include('is not your union so this assignment is not authorized.')
          expect(response).to render_template("new")
        end
      end

      describe "update/edit" do
        it "won't allow edit of other union's agreement" do
          rec = Rec.create! invalid_union.merge(authorizer: @admin)
          scoped_get :edit, {:id => rec.to_param }
          expect(response).to be_forbidden
        end

        it "won't allow update of other union's agreement" do
          rec = Rec.create! invalid_union.merge(authorizer: @admin)
          scoped_put :update, {:id => rec.to_param, :rec => { name: "blah" } }
          expect(response).to be_forbidden
        end

        it "won't allow assignment to non-collegue" do
          rec = Rec.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          scoped_put :update, {:id => rec.to_param, :rec => { person_id: invalid_person[:person_id] } }
          expect(assigns(:rec).errors.count).to eq(1)
          expect(assigns(:rec).errors[:person]).to include('is not a colleague from your union so this assignment is not authorized.')
          expect(response).to render_template("edit")
        end

        it "won't allow assignment to other union" do
          rec = Rec.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          scoped_put :update, {:id => rec.to_param, :rec => { union_id: invalid_union[:union_id] } }
          expect(assigns(:rec).errors.count).to eq(1)
          expect(assigns(:rec).errors[:union]).to include('is not your union so this assignment is not authorized.')
          expect(response).to render_template("edit")
        end
      end
    end

    describe "High privilege access" do
      login_admin

      describe "POST create" do
        it "allows assignment to non-colleague" do
          person = FactoryGirl.create(:authorized_person)
          expect(person.union_id).not_to eq(subject.current_person.union_id)
          
          scoped_post :create, {:rec => valid_attributes.merge({person_id: person.id})}
          expect(assigns(:rec).errors[:person]).to be_empty
          expect(response).not_to render_template("new")
        end

        it "allows assignment to other union" do
          union = FactoryGirl.create(:union)
          expect(union.id).not_to eq(subject.current_person.union_id)
          
          scoped_post :create, {:rec => valid_attributes.merge({union_id: union.id})}
          expect(assigns(:rec).errors[:union]).to be_empty
          expect(response).not_to render_template("new")
        end
      end

      describe "edit/update" do
        it "allows edit of other union's agreement" do
          rec = Rec.create! valid_attributes.merge(union_id: @union.id)
          scoped_get :edit, {:id => rec.to_param }
          expect(response).to be_successful
          expect(response).to render_template("edit")
        end

        it "allows update of other union's agreement" do
          rec = Rec.create! valid_attributes.merge(union_id: @union.id)
          scoped_put :update, {:id => rec.to_param, :rec => { name: "blah" } }
          expect(response).to redirect_to(assigns(:rec))
        end

        it "allows assignment to non-collegue" do
          rec = Rec.create! valid_attributes
          union = FactoryGirl.create(:union)
          expect(union.id).not_to eq(subject.current_person.union_id)
          
          # Trigger the behavior that occurs when invalid params are submitted
          scoped_put :update, {:id => rec.to_param, :rec => { union_id: union.id } }
          expect(assigns(:rec).errors[:person]).to be_empty
          expect(response).not_to render_template("edit")
        end

        it "allows assignment to other union" do
          rec = Rec.create! valid_attributes
          person = FactoryGirl.create(:authorized_person)
          expect(person.union_id).not_to eq(subject.current_person.union_id)
          
          # Trigger the behavior that occurs when invalid params are submitted
          scoped_put :update, {:id => rec.to_param, :rec => { person_id: person.id } }
          expect(assigns(:rec).errors[:person]).to be_empty
          expect(response).not_to render_template("edit")
        end
      end
    end 
  end

  describe "Notifications" do
    login_admin

    it "will send thank you email" do
      expect {
        scoped_post :create, {:rec => valid_attributes}
        expect(ActionMailer::Base.deliveries.last.subject).to include("Thanks")
        expect(ActionMailer::Base.deliveries.last.to).to include(@admin.email)
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "will send notifications" do
      u = Union.find(valid_attributes[:union_id])
      c = Company.find(valid_attributes[:company_id])

      subject.current_person.follow! u

      follower1 = FactoryGirl.create(:person, authorizer: @admin)
      follower1.follow! u

      follower2 = FactoryGirl.create(:person, authorizer: @admin)
      follower2.follow! c

      follower3 = FactoryGirl.create(:person, authorizer: @admin)
      follower3.follow! u
      follower3.follow! c
      
      follower4 = FactoryGirl.create(:person, authorizer: @admin)
      follower4.follow! FactoryGirl.create(:company) # Shouldn't be notified

      expect {
        scoped_post :create, {:rec => valid_attributes}
        messages = ActionMailer::Base.deliveries

        # these should probably be separate tests

        # Shouldn't notify current user, even if following
        expect(messages.select{|m| m.to == [subject.current_person.email] && m.subject.include?("has posted an agreement")}.count).to eq(0) 
        
        # should notify if following union
        expect(messages.select{|m| m.to == [follower1.email] && m.subject.include?("has posted an agreement")}.count).to eq(1) 
        
        # should notify if following company
        expect(messages.select{|m| m.to == [follower2.email] && m.subject.include?("has posted an agreement")}.count).to eq(1)
      
        # should only notify once even if following both union and company
        expect(messages.select{|m| m.to == [follower3.email] && m.subject.include?("has posted an agreement")}.count).to eq(1) 
        
        # shouldn't notify if following something else
        expect(messages.select{|m| m.to == [follower4.email] && m.subject.include?("has posted an agreement")}.count).to eq(0) 
        
      }.to change { ActionMailer::Base.deliveries.count }.by(4) # Thanks + 3 notifications
    end


    # it "union and company followers are made to follow new rec" do
    #   u = Union.find(valid_attributes[:union_id])
    #   c = Company.find(valid_attributes[:company_id])

    #   follower1 = FactoryGirl.create(:person, authorizer: @admin)
    #   follower1.follow! u

    #   follower2 = FactoryGirl.create(:person, authorizer: @admin)
    #   follower2.follow! c

    #   post :create, {:rec => valid_attributes}
    #   assigns(:rec).followers(Person).count.should eq(2)
    # end

    it "person assigned is made to follow new rec" do
      scoped_post :create, {:rec => valid_attributes}
      expect(assigns(:rec).followers(Person)).to include(subject.current_person)
    end
  end

  describe "Basic Functionality" do 
    # FIXME recs can be created without a start date but this breaks show action
    login_admin

    describe "GET index" do
      it "assigns division's recs as @recs" do
        rec_in = Rec.create! valid_attributes
        rec_in.divisions << @division

        rec_out = Rec.create! valid_attributes.merge(name: "other agreement")
        other_division = FactoryGirl.create(:division, name: "other_division", short_name: "other")
        rec_out.divisions << other_division

        scoped_get :index
        expect(assigns(:recs)).to include(rec_in) # Have database cleaning issues
        expect(assigns(:recs)).not_to include(rec_out) # Have database cleaning issues
        other_division.destroy
      end

      it "returns not found if division is missing" do
        scoped_get :index, {division_id: "junk"}
        assert expect(response.status).to eq(404)
      end
    end

    describe "GET show" do
      it "assigns the requested rec as @rec" do
        rec = Rec.create! valid_attributes
        scoped_get :show, {:id => rec.to_param}
        expect(assigns(:rec)).to eq(rec)
      end
    end

    describe "GET new" do
      it "assigns a new rec as @rec" do
        scoped_get :new
        expect(assigns(:rec)).to be_a_new(Rec)
      end
      
      it "assigns @division into @rec's divisions" do
        scoped_get :new
        
        expect(assigns(:rec).divisions).to include(@division)
      end
    end

    describe "GET edit" do
      it "assigns the requested rec as @rec" do
        rec = Rec.create! valid_attributes
        scoped_get :edit, {:id => rec.to_param}
        expect(assigns(:rec)).to eq(rec)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Rec" do
          expect {
            scoped_post :create, {:rec => valid_attributes}
          }.to change(Rec, :count).by(1)
        end

        it "assigns a newly created rec as @rec" do
          scoped_post :create, {:rec => valid_attributes}
          expect(assigns(:rec)).to be_a(Rec)
          expect(assigns(:rec)).to be_persisted
        end

        it "redirects to the created rec" do
          scoped_post :create, {:rec => valid_attributes}
          expect(response).to redirect_to(Rec.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved rec as @rec" do
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Rec).to receive(:save).and_return(false)
          scoped_post :create, {:rec => { "name" => "invalid value" }}
          expect(assigns(:rec)).to be_a_new(Rec)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Rec).to receive(:save).and_return(false)
          scoped_post :create, {:rec => { "name" => "invalid value" }}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested rec" do

          rec = Rec.create! valid_attributes
          # Assuming there are no other recs in the database, this
          # specifies that the Rec created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          expect_any_instance_of(Rec).to receive(:update).with({ "name" => "MyText" })
          scoped_put :update, {:id => rec.to_param, :rec => { "name" => "MyText" }}
        end

        it "assigns the requested rec as @rec" do
          rec = Rec.create! valid_attributes
          scoped_put :update, {:id => rec.to_param, :rec => valid_attributes}
          expect(assigns(:rec)).to eq(rec)
        end

        it "redirects to the rec" do
          rec = Rec.create! valid_attributes
          scoped_put :update, {:id => rec.to_param, :rec => valid_attributes}
          expect(response).to redirect_to(rec)
        end
      end

      describe "with invalid params" do
        it "assigns the rec as @rec" do
          rec = Rec.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Rec).to receive(:save).and_return(false)
          scoped_put :update, {:id => rec.to_param, :rec => { "name" => "invalid value" }}
          expect(assigns(:rec)).to eq(rec)
        end

        it "re-renders the 'edit' template" do
          rec = Rec.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Rec).to receive(:save).and_return(false)
          scoped_put :update, {:id => rec.to_param, :rec => { "name" => "invalid value" }}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested rec" do
        rec = Rec.create! valid_attributes
        expect {
          scoped_delete :destroy, {:id => rec.to_param}
        }.to change(Rec, :count).by(-1)
      end

      it "redirects to the recs list" do
        rec = Rec.create! valid_attributes
        scoped_delete :destroy, {:id => rec.to_param}
        expect(response).to redirect_to(recs_url)
      end
    end
  end
end