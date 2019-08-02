FactoryBot.define do
  factory :user do
    email { 'example@example.com' }
    username { 'example' }
    password { 'foobar123' }

    trait :admin do
      role { 'admin' }
    end
  end
end
