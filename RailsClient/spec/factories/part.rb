#在任何时候都创建
FactoryGirl.define do
  factory :terminator, class: Part do
    id 1
  end

  factory :wire, class: Part do
    id 2
  end

  factory :part do
    id 3
  end
end