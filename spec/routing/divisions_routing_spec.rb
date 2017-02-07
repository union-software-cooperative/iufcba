require "spec_helper"

describe DivisionsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/divisions")).to route_to("divisions#index")
    end

    it "routes to #new" do
      expect(get("/divisions/new")).to route_to("divisions#new")
    end

    it "routes to #edit" do
      expect(get("/divisions/1/edit")).to route_to("divisions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/divisions")).to route_to("divisions#create")
    end

    it "routes to #update" do
      expect(put("/divisions/1")).to route_to("divisions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/divisions/1")).to route_to("divisions#destroy", :id => "1")
    end

  end
end 
