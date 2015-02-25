require 'rails_helper'

describe User do
  it "is persistable" do
    expect(User.first.email).to eq('larrythecableguy@example.com')
  end
end
