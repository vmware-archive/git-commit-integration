require 'rails_helper'

RSpec.describe "repos/edit", type: :view do
  before(:each) do
    @repo = assign(:repo, Repo.create!(
      :url => "MyText",
      :hook => "MyText"
    ))
  end

  it "renders the edit repo form" do
    render

    assert_select "form[action=?][method=?]", repo_path(@repo), "post" do

      assert_select "textarea#repo_url[name=?]", "repo[url]"

      assert_select "textarea#repo_hook[name=?]", "repo[hook]"
    end
  end
end
