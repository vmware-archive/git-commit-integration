require 'rails_helper'

describe "home/show.html.erb" do
  it "renders title" do
    render
    expect(rendered).to match("Git Commit Integration")
  end
end
