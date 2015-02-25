# This will guess the User class
FactoryGirl.define do
  sequence(:user_email) { |n| "jeff.foxworthy#{pad_zeros(n)}@example.com" }
  factory :user do
    email { generate(:user_email) }
  end
end

def pad_zeros(number, places = 3)
  # left pad with zeros for sorting
  number.to_s.rjust(places, '0')
end
