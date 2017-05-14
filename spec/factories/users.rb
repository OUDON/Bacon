FactoryGirl.define do
  factory :user do
    user_name      "test_user"
    atcoder_id     "test_user"
    atcoder_rating 0
    admin          false
    email          "test@example.com"
  end
end
