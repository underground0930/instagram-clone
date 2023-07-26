# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    body { "MyText!" }
    association :user
    after(:build) do |post|
      post.images.attach(io: File.open('db/fixtures/dummy1.png'), filename: 'dummy1.png', content_type: 'image/png')
      post.images.attach(io: File.open('db/fixtures/dummy2.png'), filename: 'dummy2.png', content_type: 'image/png')
      post.images.attach(io: File.open('db/fixtures/dummy3.png'), filename: 'dummy3.png', content_type: 'image/png')
    end
  end
end

