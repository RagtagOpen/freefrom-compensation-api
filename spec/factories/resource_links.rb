FactoryBot.define do
  factory :resource_link do
    trait :with_resource do
      resource { create(:resource, :with_resource_category) }
    end

    trait :valid do
      with_resource
    end
  end
end
