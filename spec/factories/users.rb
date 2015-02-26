include FactoryHelper

FactoryGirl.define do
  sequence(:user_email) { |n| "jeff.foxworthy#{pad_zeros(n)}@example.com" }
  factory :user do
    email { generate(:user_email) }
  end
end
