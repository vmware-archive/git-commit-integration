require "rails_helper"

RSpec.describe ParentCommitsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/parent_commits").to route_to("parent_commits#index")
    end

    it "routes to #new" do
      expect(:get => "/parent_commits/new").to route_to("parent_commits#new")
    end

    it "routes to #show" do
      expect(:get => "/parent_commits/1").to route_to("parent_commits#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/parent_commits/1/edit").to route_to("parent_commits#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/parent_commits").to route_to("parent_commits#create")
    end

    it "routes to #update" do
      expect(:put => "/parent_commits/1").to route_to("parent_commits#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/parent_commits/1").to route_to("parent_commits#destroy", :id => "1")
    end

  end
end
