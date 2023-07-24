FactoryBot.define do
  factory :user do
    username { "hoge" }
    email { "hoge@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end