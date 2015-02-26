require 'rails_helper'

RSpec.describe "repos/index", type: :view do
  before(:each) do
    assign(:repos, [
      Repo.create!(
        :url => "MyText",
        :hook => "MyText"
      ),
      Repo.create!(
        :url => "MyText",
        :hook => "MyText"
      )
    ])
  end

  it "renders a list of repos" do
    render
    assert_select "tr>td", :text => "MyText".to_s
    assert_select "tr>td", :text => "MyText".to_s
  end
end
