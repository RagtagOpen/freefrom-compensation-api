FactoryBot.define do
  factory :mindset do
    trait :with_resource_category do
      resource_category { create(:resource_category) }
    end

    trait :valid do
      with_resource_category
    end
  end
end
