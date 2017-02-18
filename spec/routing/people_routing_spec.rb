require "rails_helper"

describe PeopleController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/en/people")).to route_to("people#index", locale: "en")
    end

    #it "routes to #new" do
    #  get("/en/people/new").should route_to("people#new", locale: "en")
    #end

    #it "routes to #show" do
    #  get("/en/people/1").should route_to("people#show", id: "1", locale: "en")
    #end

    it "routes to #edit" do
      expect(get("/en/people/1/edit")).to route_to("people#edit", id: "1", locale: "en")
    end

    #it "routes to #create" do
    #  post("/en/people").should route_to("people#create", locale: "en")
    #end

    it "routes to #update" do
      expect(put("/en/people/1")).to route_to("people#update", id: "1", locale: "en")
    end

    it "routes to #destroy" do
      expect(delete("/en/people/1")).to route_to("people#destroy", id: "1", locale: "en")
    end

  end
end
