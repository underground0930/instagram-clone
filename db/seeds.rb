# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "factory_bot_rails"

puts "============== start seed [user] =============="

user1 = FactoryBot.create(:user, 
  username: "taro",
  email: "taro@example.com",
)

user2 = FactoryBot.create(:user, 
  username: "jiro",
  email: "jiro@example.com",
)

puts "============== start seed [posts] =============="

[user1,user2].each do |user|
  10.times.each do
    post = user.posts.build(body: Faker::Hacker.say_something_smart)
    post.images.attach(io: File.open("db/fixtures/dummy1.png"), filename: "dummy")
    post.images.attach(io: File.open("db/fixtures/dummy2.png"), filename: "dummy")
    post.images.attach(io: File.open("db/fixtures/dummy3.png"), filename: "dummy")
    post.save
    puts "#{user.username}'s post has created"
  end
end
