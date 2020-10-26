require "rails_helper"

describe DivisionsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/en/divisions")).to route_to("divisions#index", locale: "en")
    end

    it "routes to #new" do
      expect(get("/en/divisions/new")).to route_to("divisions#new", locale: "en")
    end

    it "routes to #edit" do
      expect(get("/en/divisions/1/edit")).to route_to("divisions#edit", id: "1", locale: "en")
    end

    it "routes to #create" do
      expect(post("/en/divisions")).to route_to("divisions#create", locale: "en")
    end

    it "routes to #update" do
      expect(put("/en/divisions/1")).to route_to("divisions#update", id: "1", locale: "en")
    end

    it "routes to #destroy" do
      expect(delete("/en/divisions/1")).to route_to("divisions#destroy", id: "1", locale: "en")
    end

  end
end 
