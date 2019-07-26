FactoryBot.define do
  factory :user do
    password { 'foobar123' }

    trait :admin do
      role { 'admin' }
    end
  end
end
