require "rails_helper"

RSpec.describe HotCatchAppsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hot_catch_apps").to route_to("hot_catch_apps#index")
    end

    it "routes to #new" do
      expect(:get => "/hot_catch_apps/new").to route_to("hot_catch_apps#new")
    end

    it "routes to #show" do
      expect(:get => "/hot_catch_apps/1").to route_to("hot_catch_apps#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/hot_catch_apps/1/edit").to route_to("hot_catch_apps#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/hot_catch_apps").to route_to("hot_catch_apps#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/hot_catch_apps/1").to route_to("hot_catch_apps#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/hot_catch_apps/1").to route_to("hot_catch_apps#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/hot_catch_apps/1").to route_to("hot_catch_apps#destroy", :id => "1")
    end

  end
end
