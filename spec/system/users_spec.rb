require 'rails_helper'

RSpec.describe "Users", type: :system do

  describe "ユーザー情報編集" do
    let!(:user) { FactoryBot.create(:user) }
    before do
      @user_attributes = FactoryBot.attributes_for(:user)
      log_in(@user_attributes)
    end

    it "ユーザー情報が編集出来ること" do
      visit "/mypage/account/edit"
      fill_in name: "user[username]", with: "dummy_man"
      fill_in name: "user[email]", with: "update@example.com"
      attach_file("user[avatar]", "#{Rails.root}/db/fixtures/dummy1.png")
      click_on "編集"
      sleep 1
      user.reload
      expect(page).to have_content t('controllers.users.update.success')
      expect(user.username).to eq "dummy_man"
      expect(user.email).to eq "update@example.com"
      expect(user.avatar.attached?).to eq true
    end
  end

end
