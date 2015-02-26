require 'rails_helper'

describe "home/show.html.erb" do
  it "renders title" do
    render
    expect(rendered).to match("HOME PAGE")
  end
end
