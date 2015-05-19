#在任何时候都创建
FactoryGirl.define do
  factory :source, class: Location do
    id 1
    name "Source"
  end

  factory :destination, class: Location do
    id 2
    name "Destination"
  end

  factory :another_dest, class: Location do
    id 3
    name "AnotherDestination"
  end
end