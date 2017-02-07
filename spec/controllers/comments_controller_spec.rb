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

describe CommentsController do

  before(:all) do
    @division = FactoryGirl.create(:division)
    @union = FactoryGirl.create(:union)
    @owner_union = owner_union
    @company = FactoryGirl.create(:company)
    @admin = admin
    @agreement =  FactoryGirl.create(:agreement, union_id: @union.id, company_id: @company.id, person_id: @admin.id, authorizer: admin )  
    @post =  FactoryGirl.create(:post, body: "body text", parent_id: @agreement.id, parent_type: "Rec", person: @admin) 
  end
  
  after(:all) do
    [@division, @union, @owner_union, @company, @admin, @agreement, @post].each(&:destroy)
  end


  # This should return the minimal set of attributes required to create a valid
  # Comment. As you add validations to Comment, be sure to
  # adjust the attributes here as well.
  
  let(:valid_attributes) { FactoryGirl.attributes_for(:comment, body: "body text", post_id: @post.id) } 
  
  describe "POST create" do

    login_person

    describe "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, {:comment => valid_attributes, division_id: @division.id}
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, {:comment => valid_attributes, division_id: @division.id}
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it "redirects to the created comment" do
        post :create, {:comment => valid_attributes, division_id: @division.id}
        expect(response).to redirect_to(@agreement)
      end
    end
  end

  describe "Notifications" do
    login_person

    before(:each) do
      ActionMailer::Base.deliveries = []
    end

    it "will send notifications" do
      commenter1 = FactoryGirl.create(:person, authorizer: @admin)
      comment1 = Comment.create! valid_attributes.merge(person: commenter1)
      
      expect {
        post :create, {:comment => valid_attributes, division_id: @division.id}
        messages = ActionMailer::Base.deliveries
        
        # notification should be sent to admin because admin was the original poster
        expect(messages.select{|m| m.to == [@admin.email] && m.subject.include?("has left a comment")}.count).to eq(1) 
         
        # notifications should be sent to commenter1 because they commented on the same posting
        expect(messages.select{|m| m.to == [commenter1.email] && m.subject.include?("has left a comment")}.count).to eq(1) 
        
        # notifications should not be sent to current_person because they are posting
        expect(messages.select{|m| m.to == [subject.current_person.email] && m.subject.include?("has left a comment")}.count).to eq(0) 
      }.to change { ActionMailer::Base.deliveries.count }.by(2) # Thanks + 3 notifications
    end
  end

  describe "DELETE destroy" do

    login_person

    it "destroys the requested comment when the user created it" do
      comment = Comment.create! valid_attributes.merge(person: subject.current_person)
      expect {
        delete :destroy, {:id => comment.to_param, division_id: @division.id}
      }.to change(Comment, :count).by(-1)
    end

    it "does not destroy the requested comment when someone else created it" do
      comment = Comment.create! valid_attributes.merge(person: @admin)
      expect {
        delete :destroy, {:id => comment.to_param, division_id: @division.id}
      }.to change(Comment, :count).by(0)
    end

    it "redirects to the comments list" do
      comment = Comment.create! valid_attributes
      delete :destroy, {:id => comment.to_param, division_id: @division.id}
      expect(response).to redirect_to(@agreement)
    end
  end

end
