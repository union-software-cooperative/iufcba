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

describe PostsController do
  before(:all) do
    @division = FactoryGirl.create(:division)
    @union = FactoryGirl.create(:union)
    @owner_union = owner_union
    @company = FactoryGirl.create(:company)
    @admin = admin
    @agreement =  FactoryGirl.create(:agreement, union_id: @union.id, company_id: @company.id, person_id: @admin.id, authorizer: admin )  
  end
  
  after(:all) do
    # [@division, @union, @company, @agreement].each(&:destroy)
  end

  # This should return the minimal set of attributes required to create a valid
  # Post. As you add validations to Post, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for(:post, body: "body text", parent_id: @agreement.id, parent_type: "Rec") } 
  
  describe "POST create" do

    login_person

    describe "with valid params" do
      it "creates a new Post" do
        expect {
          scoped_post :create, {:post => valid_attributes}
        }.to change(Post, :count).by(1)
      end

      it "assigns a newly created post as @post" do
        scoped_post :create, {:post => valid_attributes}
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
      end

      it "redirects to the created post" do
        scoped_post :create, {:post => valid_attributes}
        expect(response).to redirect_to(@agreement)
      end
    end

    # describe "with invalid params" do
    #   login_person

    #   it "assigns a newly created but unsaved post as @post" do
    #     # Trigger the behavior that occurs when invalid params are submitted
    #     Post.any_instance.stub(:save).and_return(false)
    #     scoped_post :create, {:post => { "body" => "invalid value" }}
    #     assigns(:post).should be_a_new(Post)
    #   end

    #   it "re-renders the 'new' template" do
    #     # Trigger the behavior that occurs when invalid params are submitted
    #     Post.any_instance.stub(:save).and_return(false)
    #     scoped_post :create, {:post => { "body" => "invalid value" }}
    #     response.should render_template("new")
    #   end
    # end
  end

  describe "Notifications" do
    login_person

    before(:each) do
      ActionMailer::Base.deliveries = []
    end

    it "will send notifications" do
      parent = Rec.find(valid_attributes[:parent_id])

      follower1 = FactoryGirl.create(:person, authorizer: @admin)
      follower1.follow! parent

      subject.current_person.follow! parent

      expect {
        scoped_post :create, {:post => valid_attributes}
        messages = ActionMailer::Base.deliveries

        # notification should be sent to admin because admin is the rec assignee
        expect(messages.select{|m| m.to == [@admin.email] && m.subject.include?("has posted a message")}.count).to eq(1) 
         
        # notifications should be sent to  follower1 because they are following the current rec
        expect(messages.select{|m| m.to == [follower1.email] && m.subject.include?("has posted a message")}.count).to eq(1) 
        
        # notifications should not be sent to current_person because they are posting
        expect(messages.select{|m| m.to == [subject.current_person.email] && m.subject.include?("has posted a message")}.count).to eq(0) 
      }.to change { ActionMailer::Base.deliveries.count }.by(2) # Thanks + 3 notifications
    end
  end

  describe "DELETE destroy" do

    login_person

    it "destroys the requested post when user created post" do
      post = Post.create! valid_attributes.merge(person: subject.current_person)
      expect {
        scoped_delete :destroy, {:id => post.to_param}
      }.to change(Post, :count).by(-1)
    end

    it "does not destroy the requested post when another user created post" do
      post = Post.create! valid_attributes.merge(person: @admin)
      expect {
        scoped_delete :destroy, {:id => post.to_param}
      }.to change(Post, :count).by(0)
    end


    it "redirects to the posts list" do
      post = Post.create! valid_attributes.merge(person: subject.current_person)
      parent = post.parent

      scoped_delete :destroy, {:id => post.to_param}
      expect(response).to redirect_to(parent)
    end
  end

end
