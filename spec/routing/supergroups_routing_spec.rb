require "spec_helper"

describe SupergroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/companies").should route_to("supergroups#index", :type=>"Company")
    end

    it "routes to #new" do
      get("/companies/new").should route_to("supergroups#new", :type=>"Company")
    end

    it "routes to #show" do
      get("/companies/1").should route_to("supergroups#show", :id => "1", :type=>"Company")
    end

    it "routes to #edit" do
      get("/companies/1/edit").should route_to("supergroups#edit", :id => "1", :type=>"Company")
    end

    it "routes to #create" do
      post("/companies").should route_to("supergroups#create", :type=>"Company")
    end

    it "routes to #update" do
      put("/companies/1").should route_to("supergroups#update", :id => "1", :type=>"Company")
    end

    it "routes to #destroy" do
      delete("/companies/1").should route_to("supergroups#destroy", :id => "1", :type=>"Company")
    end

    it "routes to #index" do
      get("/unions").should route_to("supergroups#index", :type=>"Union")
    end

    it "routes to #new" do
      get("/unions/new").should route_to("supergroups#new", :type=>"Union")
    end

    it "routes to #show" do
      get("/unions/1").should route_to("supergroups#show", :id => "1", :type=>"Union")
    end

    it "routes to #edit" do
      get("/unions/1/edit").should route_to("supergroups#edit", :id => "1", :type=>"Union")
    end

    it "routes to #create" do
      post("/unions").should route_to("supergroups#create", :type=>"Union")
    end

    it "routes to #update" do
      put("/unions/1").should route_to("supergroups#update", :id => "1", :type=>"Union")
    end

    it "routes to #destroy" do
      delete("/unions/1").should route_to("supergroups#destroy", :id => "1", :type=>"Union")
    end



  end
end
