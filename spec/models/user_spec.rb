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

  end

end
