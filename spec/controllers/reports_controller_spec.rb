require 'rails_helper'

RSpec.describe ReportsController, type: :controller do

  describe "GET #external_link_ref_commits" do
    it "returns http success" do
      get :external_link_ref_commits, external_link_id: create(:external_link).id
      expect(response).to have_http_status(:success)
    end
  end

end
