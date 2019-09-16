FactoryBot.define do
  factory :quiz_response do
    trait :with_quiz_question do
      quiz_question
    end

    trait :valid do
      with_quiz_question
    end
  end
end
