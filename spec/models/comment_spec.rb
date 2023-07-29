# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.build(:comment) }
  describe "通常時" do

    it "commentが有効であること" do
      expect(comment).to be_valid
    end

    it "bodyは必須なのでinvalidになること" do
      comment.body = ""
      expect(comment).to_not be_valid
    end

    it "bodyは1000文字以下であること" do
      comment.body = "a" * 1000
      expect(comment).to be_valid
    end

    it "bodyは1001文字以上は通らないこと" do
      comment.body = "a" * 1001
      expect(comment).to_not be_valid
    end


  end
end
