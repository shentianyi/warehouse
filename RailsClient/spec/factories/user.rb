FactoryGirl.define do
  factory :user do
    id 1
    email 'user@test.com'
    password '1111'
    password_confirmation '1111'
    role_id 400
    is_sys 0
  end

  factory :admin, class: User do
    id 2
    email 'admin@test.com'
    password '1111'
    password_confirmation '1111'
    role_id 100
    is_sys 1
  end
end