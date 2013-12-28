FactoryGirl.define do
  factory :user do
    name "Max Wittmann"
    email "max@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end