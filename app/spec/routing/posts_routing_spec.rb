require "rails_helper"

describe PostsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/en/1/posts")).to route_to("posts#index", division_id: "1", locale: "en")
    end

    it "routes to #new" do
      expect(get("/en/1/posts/new")).to route_to("posts#new", division_id: "1", locale: "en")
    end

    it "routes to #show" do
      expect(get("/en/1/posts/1")).to route_to("posts#show", id: "1", division_id: "1", locale: "en")
    end

    it "routes to #edit" do
      expect(get("/en/1/posts/1/edit")).to route_to("posts#edit", id: "1", division_id: "1", locale: "en")
    end

    it "routes to #create" do
      expect(post("/en/1/posts")).to route_to("posts#create", division_id: "1", locale: "en")
    end

    it "routes to #update" do
      expect(put("/en/1/posts/1")).to route_to("posts#update", id: "1", division_id: "1", locale: "en")
    end

    it "routes to #destroy" do
      expect(delete("/en/1/posts/1")).to route_to("posts#destroy", id: "1", division_id: "1", locale: "en")
    end

  end
end
