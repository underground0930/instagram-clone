# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
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

end
