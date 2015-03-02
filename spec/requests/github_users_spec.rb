require 'rails_helper'

RSpec.describe "GithubUsers", type: :request do
  describe "GET /github_users" do
    it "works! (now write some real specs)" do
      get github_users_path
      expect(response).to have_http_status(200)
    end
  end
end
