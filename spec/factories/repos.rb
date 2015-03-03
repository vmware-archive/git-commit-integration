FactoryGirl.define do
  factory :repo do
    association :user
    url "https://github.com/pivotaltracker/dummytest.git"
    hook "{}"
    github_identifier "12345"
  end

end
