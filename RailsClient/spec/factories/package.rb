FactoryGirl.define do
  factory :p1, class: Package do
    custom_id 'p1'
    quantity 1000
    user_id 1
    check_in_time '23.03.14'
    association :containable, factory: :terminator, strategy: :build
  end

  factory :p2, class: Package do
    custom_id 'p2'
    quantity 1000
    user_id 1
    check_in_time '21.03.14'
    association :containable, factory: :terminator, strategy: :build
  end

  factory :p3, class: Package do
    custom_id 'p3'
    quantity 1000
    user_id 1
    check_in_time '29.03.14'
    association :containable, factory: :wire, strategy: :build
  end
end