require 'rails_helper'

RSpec.describe "repos/new", type: :view do
  before(:each) do
    assign(:repo, Repo.new(
      :url => "MyText",
      :hook => "MyText"
    ))
  end

  it "renders new repo form" do
    render

    assert_select "form[action=?][method=?]", repos_path, "post" do

      assert_select "textarea#repo_url[name=?]", "repo[url]"

      assert_select "textarea#repo_hook[name=?]", "repo[hook]"
    end
  end
end
