FactoryBot.define do
  factory :resource do
    trait :with_resource_category do
      resource_category
    end
  end
end
