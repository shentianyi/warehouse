#在任何时候都创建
FactoryGirl.define do
  factory :sender, class: User do
    id 1
    email 'sender@test.com'
    password '1111'
    password_confirmation '1111'
    role_id 300
    is_sys 0
    location_id 1
  end

  factory :receiver, class: User do
    id 2
    email 'receiver@test.com'
    password '1111'
    password_confirmation '1111'
    role_id 400
    is_sys 0
    location_id 2
  end

  factory :order, class: User do
    id 3
    email 'order@test.com'
    password '1111'
    password_confirmation '1111'
    role_id 500
    is_sys 0
    location_id 3
  end

  factory :admin, class: User do
    id 4
    email 'admin@test.com'
    password '1111'
    password_confirmation '1111'
    role_id 100
    is_sys 1
  end
end