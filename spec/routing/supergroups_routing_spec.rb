require "spec_helper"

describe SupergroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/1/companies").should route_to("supergroups#index", :type=>"Company", :division_id => "1")
    end

    it "routes to #new" do
      get("/1/companies/new").should route_to("supergroups#new", :type=>"Company", :division_id => "1")
    end

    it "routes to #show" do
      get("/1/companies/1").should route_to("supergroups#show", :id => "1", :type=>"Company", :division_id => "1")
    end

    it "routes to #edit" do
      get("/1/companies/1/edit").should route_to("supergroups#edit", :id => "1", :type=>"Company", :division_id => "1")
    end

    it "routes to #create" do
      post("/1/companies").should route_to("supergroups#create", :type=>"Company", :division_id => "1")
    end

    it "routes to #update" do
      put("/1/companies/1").should route_to("supergroups#update", :id => "1", :type=>"Company", :division_id => "1")
    end

    it "routes to #destroy" do
      delete("/1/companies/1").should route_to("supergroups#destroy", :id => "1", :type=>"Company", :division_id => "1")
    end

    it "routes to #index" do
      get("/1/unions").should route_to("supergroups#index", :type=>"Union", :division_id => "1")
    end

    it "routes to #new" do
      get("/1/unions/new").should route_to("supergroups#new", :type=>"Union", :division_id => "1")
    end

    it "routes to #show" do
      get("/1/unions/1").should route_to("supergroups#show", :id => "1", :type=>"Union", :division_id => "1")
    end

    it "routes to #edit" do
      get("/1/unions/1/edit").should route_to("supergroups#edit", :id => "1", :type=>"Union", :division_id => "1")
    end

    it "routes to #create" do
      post("/1/unions").should route_to("supergroups#create", :type=>"Union", :division_id => "1")
    end

    it "routes to #update" do
      put("/1/unions/1").should route_to("supergroups#update", :id => "1", :type=>"Union", :division_id => "1")
    end

    it "routes to #destroy" do
      delete("/1/unions/1").should route_to("supergroups#destroy", :id => "1", :type=>"Union", :division_id => "1")
    end
  end
end
