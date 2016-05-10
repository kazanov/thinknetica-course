FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }
    question
    user
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
