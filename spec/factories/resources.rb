FactoryBot.define do
  factory :resource do
    state { 'NY' }

    trait :with_resource_category do
      resource_category
    end
  end
end
