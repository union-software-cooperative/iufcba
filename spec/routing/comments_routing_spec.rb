require "spec_helper"

describe CommentsController do
  describe "routing" do

    it "routes to #index" do
      get("/1/comments").should route_to("comments#index", :division_id => "1")
    end

    it "routes to #new" do
      get("/1/comments/new").should route_to("comments#new", :division_id => "1")
    end

    it "routes to #show" do
      get("/1/comments/1").should route_to("comments#show", :id => "1", :division_id => "1")
    end

    it "routes to #edit" do
      get("/1/comments/1/edit").should route_to("comments#edit", :id => "1", :division_id => "1")
    end

    it "routes to #create" do
      post("/1/comments").should route_to("comments#create", :division_id => "1")
    end

    it "routes to #update" do
      put("/1/comments/1").should route_to("comments#update", :id => "1", :division_id => "1")
    end

    it "routes to #destroy" do
      delete("/1/comments/1").should route_to("comments#destroy", :id => "1", :division_id => "1")
    end

  end
end
