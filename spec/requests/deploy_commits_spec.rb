require 'rails_helper'

RSpec.describe "DeployCommits", type: :request do
  describe "GET /deploy_commits" do
    it "works! (now write some real specs)" do
      get deploy_commits_path
      expect(response).to be_redirect # omniauth not mocked, no authentication
    end
  end
end
