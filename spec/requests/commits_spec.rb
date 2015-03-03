require 'rails_helper'

RSpec.describe "Commits", type: :request do
  describe "GET /repos/:id/commits" do
    it "works! (now write some real specs)" do
      get repo_commits_path(create(:repo))
      expect(response).to be_redirect # omniauth not mocked, no authentication
    end
  end
end
