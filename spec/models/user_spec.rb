# == Schema Information
#
# Table name: users
#
#  id                           :bigint           not null, primary key
#  crypted_password             :string(255)
#  email                        :string(255)      not null
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#  salt                         :string(255)
#  username                     :string(255)      not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_users_on_email              (email) UNIQUE
#  index_users_on_remember_me_token  (remember_me_token)
#  index_users_on_username           (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do

  describe "通常時" do
    let(:user) { FactoryBot.build(:user) }

    it "userが有効になること" do
      expect(user).to be_valid
    end

    it "usernameは必須なのでinvalidになること" do
      user.username = ""
      expect(user).to_not be_valid
    end

    it "usernameは重複を禁止すること" do
      user.save()
      dup_user = user.dup
      dup_user.email = "別@email.com"
      expect(dup_user).to_not be_valid
    end

    it "emailは必須なのでinvalidになること" do
      user.email = ""
      expect(user).to_not be_valid
    end

    it "これらのメールアドレスは有効なフォーマット" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid, "#{valid_address.inspect} がエラーです"
      end
    end
  
    it "これらのメールアドレスは無効なフォーマット" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid, "#{invalid_address.inspect} がエラーです"
      end
    end

    it "usernameは重複を禁止なのでinvalidになること" do
      user.save()
      dup_user = user.dup
      dup_user.username = "別の名前"
      expect(dup_user).to_not be_valid
    end

    it "passwordは必須なのでinvalidになること" do
      user.password = user.password_confirmation = ""
      expect(user).to_not be_valid
    end

    it "passwordは空白も許容しないこと" do
      user.password = user.password_confirmation = "  " * 3
      expect(user).to_not be_valid
    end

    it "passwordは最小3文字以上のこと" do
      user.password = user.password_confirmation = "a" * 2
      expect(user).to_not be_valid
    end

    it "passwordは最大20文字までのこと" do
      user.password = user.password_confirmation = "a" * 21
      expect(user).to_not be_valid
    end

  end

  describe "いいね機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post, user:user) }

    describe "#like" do
      it "いいねしたらLikeが1件増えること" do
        expect{
          user.like(post)
        }.to change(Like, :count).by 1  
      end
    end

    describe "#unlike" do
      before do
        user.like(post)
      end

      it "いいねを解除したらLikeが1件減ること" do
        expect{
          user.unlike(post)
        }.to change(Like, :count).by -1
      end
    end
    
    describe "like?" do
      it "いいねしているのでtrueを返すこと" do
        user.like(post)
        expect(user.like?(post)).to be true
      end
      it "いいねしていないのでfalseを返すこと" do
        expect(user.like?(post)).to be false
      end
    end

  end

  describe "フォロー機能" do
    describe "#follow" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user2) }
  
      it "フォローしたら、リレーションが１件増えること" do
        expect{
          user.follow(user2)
        }.to change(Relationship, :count).by 1
      end  
    end

    describe "#unfollow" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user2) }  
      
      it "アンフォローしたらリレーションが１件減ること" do
        user.follow(user2)
        expect{
          user.unfollow(user2)
        }.to change(Relationship, :count).by -1  
      end
    end

    describe "#following?" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user2) }  
      
      before do
        user.follow(user2)
      end
      it "フォローしているのでtrueになること" do
        expect(user.following?(user2)).to eq true
      end
      it "フォローしてないのでfalseになること" do
        expect(user2.following?(user)).to eq false    
      end
    end

    describe "#feed" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user2) }  
      let!(:user3) { FactoryBot.create(:user3) }  
      let!(:post) { FactoryBot.create(:post, user:user) }
      let!(:post2) { FactoryBot.create(:post, user:user2) }  
      let!(:post3) { FactoryBot.create(:post, user:user3) }  

      before do
        user.follow(user2)
      end

      context "フォローしているユーザーのfeed" do
        it "自分とフォロワーの投稿があること" do
          expect(user.feed).to include post
          expect(user.feed).to include post2
          expect(user.feed).to_not include post3
        end
      end
      
      context "フォローしていないユーザーのfeed" do
        it "自分の投稿しかないこと" do
          expect(user2.feed).to_not include post
          expect(user2.feed).to include post2
          expect(user2.feed).to_not include post3
        end
      end
    end

    describe "#recent" do
      let(:base_time) { Time.current }
      let!(:user) { FactoryBot.create(:user, created_at: base_time) }
      let!(:user2) { FactoryBot.create(:user2, created_at: base_time.ago(1.day)) }  
      let!(:user3) { FactoryBot.create(:user3, created_at: base_time.ago(2.day)) }  
      let!(:user4) { FactoryBot.create(:user4, created_at: base_time.ago(3.day)) }  

      it "最新順に3件並ぶこと" do
        expect(User.recent(3)).to eq [user,user2,user3]
      end

    end
  end

end
