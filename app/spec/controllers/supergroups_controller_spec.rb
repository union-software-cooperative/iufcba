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

shared_examples "a supergroup type" do |type|
  let(:type) {type}
  let(:type_sym) {type.downcase.to_sym}

  let(:valid_attributes) { { "name" => "name", "short_name" => "sn", "type"=> type } }

  before(:all) do
    @division = FactoryGirl.create(:division)
  end

  after(:all) do
    @division.destroy
  end

  describe "Security" do

    before(:all) do
      @admin = admin
    end

    describe "Low privilege access" do
      login_person

      describe "POST create" do
        it "allows creation of companies but not unions" do
          scoped_post :create, {type_sym => valid_attributes, type: type}
          if type == "Union"
            expect(response).to be_forbidden
          elsif type == "Company"
            expect(response).to redirect_to(assigns(:supergroup))
          end
        end
      end

      describe "edit/update" do
        it "allows edit companies, but not unions unless owned" do
          supergroup = Supergroup.create! valid_attributes
          scoped_get :edit, { id: supergroup.to_param, type: type }

          if type == "Union"
            expect(response).to be_forbidden

            supergroup = subject.current_person.union
            scoped_get :edit, { id: supergroup.to_param, type: type }
            expect(response).to render_template(:edit)
          elsif type == "Company"
            expect(response).to render_template(:edit)
          end
        end

        it "allows update companies, but not unions unless owned" do
          supergroup = Supergroup.create! valid_attributes
          scoped_put :update, { id: supergroup.to_param, type_sym => { name: "blah" }, type: type }

          if type == "Union"
            expect(response).to be_forbidden

            supergroup = subject.current_person.union
            scoped_put :update, { id: supergroup.to_param, type_sym => {name: "blah"}, type: type }
            expect(response).to redirect_to(supergroup)
          elsif type == "Company"
            expect(response).to redirect_to(supergroup)
          end
        end
      end
    end
  end

  describe "basic functionality" do
    login_admin

    describe "GET index" do
      it "assigns division's supergroups as @supergroups" do
        supergroup_in = Supergroup.create! valid_attributes
        supergroup_in.divisions << @division

        supergroup_out = Supergroup.create! valid_attributes
        other_division = FactoryGirl.create(:division, name: "other_division", short_name: "other")
        supergroup_out.divisions << other_division

        scoped_get :index, {type: type}

        expect(assigns(:supergroups)).to include(supergroup_in)
        expect(assigns(:supergroups)).not_to include(supergroup_out)
      end
    end

    describe "GET index api" do
      it "returns all #{type.pluralize} (unfiltered)" do
        if type == "Union"
          supergroup_in = Supergroup.create! valid_attributes
          supergroup_in.divisions << @division

          supergroup_out = Supergroup.create! valid_attributes
          other_division = FactoryGirl.create(:division, name: "other_division", short_name: "other")
          supergroup_out.divisions << other_division

          get :index, {type: type, format: "json", locale: I18n.default_locale}

          expect(assigns(:supergroups)).to include(supergroup_in)
          expect(assigns(:supergroups)).to include(supergroup_out)
          expect(assigns(:supergroups)).to all(be_instance_of Union)
        end
      end
    end

    describe "GET show" do
      it "assigns the requested supergroup as @supergroup" do
        supergroup = Supergroup.create! valid_attributes
        scoped_get :show, {:id => supergroup.to_param, type: type}
        expect(assigns(:supergroup)).to eq(supergroup)
      end
    end

    describe "GET new" do
      it "assigns a new supergroup as @supergroup" do
        scoped_get :new, {type: type}
        expect(assigns(:supergroup)).to be_a_new(Supergroup)
      end

      it "assigns @division into @supergroup's divisions" do
        scoped_get :new, { type: type }

        expect(assigns(:supergroup).divisions).to include(@division)
      end
    end

    describe "GET edit" do
      it "assigns the requested supergroup as @supergroup" do
        supergroup = Supergroup.create! valid_attributes
        scoped_get :edit, {:id => supergroup.to_param, type: type}
        expect(assigns(:supergroup)).to eq(supergroup)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Supergroup" do
          expect {
            scoped_post :create, {type_sym => valid_attributes, type: type}
          }.to change(Supergroup, :count).by(1)
        end

        it "assigns a newly created supergroup as @supergroup" do
          scoped_post :create, {type_sym => valid_attributes, type: type}
          expect(assigns(:supergroup)).to be_a(Supergroup)
          expect(assigns(:supergroup)).to be_persisted
        end

        it "redirects to the created supergroup" do
          scoped_post :create, {type_sym => valid_attributes, type: type}
          expect(response).to redirect_to(Supergroup.last)
        end

        it "can assign multiple divisions" do
          other_division = FactoryGirl.create(:division, name: "other_division", short_name: "other")
          scoped_post :create, { type_sym => valid_attributes.merge(divisions: [@division, other_division]), type: type }
          expect(assigns(:supergroup).divisions.size).to eq(2)
          expect(assigns(:supergroup).divisions).to include(@division, other_division)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved supergroup as @supergroup" do
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Supergroup).to receive(:save).and_return(false)
          scoped_post :create, {type_sym => { "name" => "invalid value" }, type: type}
          expect(assigns(:supergroup)).to be_a_new(Supergroup)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Supergroup).to receive(:save).and_return(false)
          scoped_post :create, {type_sym => { "name" => "invalid value" }, type: type}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested supergroup" do
          supergroup = Supergroup.create! valid_attributes
          # Assuming there are no other supergroups in the database, this
          # specifies that the Supergroup created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          expect_any_instance_of(Supergroup).to receive(:update).with({ "name" => "MyString", "type" => type })
          scoped_put :update, {:id => supergroup.to_param, type_sym => { "name" => "MyString" }, type: type}
        end

        it "assigns the requested supergroup as @supergroup" do
          supergroup = Supergroup.create! valid_attributes
          scoped_put :update, {:id => supergroup.to_param, type_sym => valid_attributes, type: type}
          expect(assigns(:supergroup)).to eq(supergroup)
        end

        it "redirects to the supergroup" do
          supergroup = Supergroup.create! valid_attributes
          scoped_put :update, {:id => supergroup.to_param, type_sym => valid_attributes, type: type}
          expect(response).to redirect_to(supergroup)
        end
      end

      describe "with invalid params" do
        it "assigns the supergroup as @supergroup" do
          supergroup = Supergroup.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Supergroup).to receive(:save).and_return(false)
          scoped_put :update, {:id => supergroup.to_param, type_sym => { "name" => "invalid value" }, type: type}
          expect(assigns(:supergroup)).to eq(supergroup)
        end

        it "re-renders the 'edit' template" do
          supergroup = Supergroup.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          allow_any_instance_of(Supergroup).to receive(:save).and_return(false)
          scoped_put :update, {:id => supergroup.to_param, type_sym => { "name" => "invalid value" }, type: type}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested supergroup" do
        supergroup = Supergroup.create! valid_attributes
        expect {
          scoped_delete :destroy, {:id => supergroup.to_param, type: type}
        }.to change(Supergroup, :count).by(-1)
      end

      it "redirects to the supergroups list" do
        supergroup = Supergroup.create! valid_attributes
        scoped_delete :destroy, {:id => supergroup.to_param, type: type}
        expect(response).to redirect_to(type.constantize)
      end
    end
  end
end

RSpec.describe SupergroupsController do
  #https://www.relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples
  it_behaves_like "a supergroup type", "Union"
  it_behaves_like "a supergroup type", "Company"
end
