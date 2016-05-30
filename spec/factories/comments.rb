FactoryGirl.define do
  factory :comment do
    sequence(:text) { |n| "Comment #{n}" }
  end

  factory :invalid_comment, class: Comment do
    text nil
  end
end
