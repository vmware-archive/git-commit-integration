require 'rails_helper'

RSpec.describe "DeployRepos", type: :request do
  describe "GET /deploy_repos" do
    it "works! (now write some real specs)" do
      get deploy_repos_path
      expect(response).to be_redirect # omniauth not mocked, no authentication
    end
  end
end
