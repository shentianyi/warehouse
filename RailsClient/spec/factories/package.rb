FactoryGirl.define do
  factory :p1, class: Package do
    id 1
    quantity 1000
    user_id 1
    check_in_time '23.03.14'
    association :part, factory: :terminator, strategy: :build
  end

  factory :p2, class: Package do
    id 2
    quantity 1000
    user_id 1
    check_in_time '21.03.14'
    association :part, factory: :terminator, strategy: :build
  end

  factory :p3, class: Package do
    id 3
    quantity 1000
    user_id 1
    check_in_time '29.03.14'
    association :part, factory: :wire, strategy: :build
  end
end