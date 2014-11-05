FactoryGirl.define do
  factory :user do
    id "test_user"
    password "1111"
    is_sys 0
  end

  factory :admin, class: User do
    id "system"
    password "1111"
    is_sys 1
  end
end