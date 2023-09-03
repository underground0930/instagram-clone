# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  title      :string(255)      not null
#  url        :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :notification do
    title { "MyString" }
    url { "MyString" }
  end
end
