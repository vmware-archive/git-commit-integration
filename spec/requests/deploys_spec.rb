require 'rails_helper'

RSpec.describe "Deploys", type: :request do
  describe "GET /deploys" do
    it "works! (now write some real specs)" do
      get deploys_path
      expect(response).to be_redirect # omniauth not mocked, no authentication
    end
  end
end
