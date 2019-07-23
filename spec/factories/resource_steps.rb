FactoryBot.define do
  factory :resource_step do
    trait :with_resource do
      resource { create(:resource, :with_resource_category) }
    end
  end
end
