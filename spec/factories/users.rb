FactoryGirl.define do
  factory :user do
    user_name      "test_user"
    atcoder_id     "test_user"
    atcoder_rating 0
    admin          false
    email          { Faker::Internet.email }

    factory :user_without_validate do
      to_create do |instance|
        instance.save validate: false
      end
    end
  end
end
