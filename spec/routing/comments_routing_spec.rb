require "rails_helper"

describe CommentsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/1/comments")).to route_to("comments#index", :division_id => "1")
    end

    it "routes to #new" do
      expect(get("/1/comments/new")).to route_to("comments#new", :division_id => "1")
    end

    it "routes to #show" do
      expect(get("/1/comments/1")).to route_to("comments#show", :id => "1", :division_id => "1")
    end

    it "routes to #edit" do
      expect(get("/1/comments/1/edit")).to route_to("comments#edit", :id => "1", :division_id => "1")
    end

    it "routes to #create" do
      expect(post("/1/comments")).to route_to("comments#create", :division_id => "1")
    end

    it "routes to #update" do
      expect(put("/1/comments/1")).to route_to("comments#update", :id => "1", :division_id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/1/comments/1")).to route_to("comments#destroy", :id => "1", :division_id => "1")
    end

  end
end
