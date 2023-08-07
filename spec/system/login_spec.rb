require 'rails_helper'

RSpec.describe "Logins", type: :system do
  before do
    @user_attributes = FactoryBot.attributes_for(:user)
  end

  describe "ログイン" do    
    context "成功" do
      it "メール、パスワードが正常に入力されている" do
        User.create(@user_attributes);
        log_in(@user_attributes)
        expect(page).to have_content "ログインに成功しました!"
      end  
    end

    context "失敗" do
      it "パスワードミスでログイン出来ない" do
        User.create(@user_attributes);
        visit login_path
        fill_in "メールアドレス", with: @user_attributes[:email]
        fill_in "パスワード", with: "unknown"
        click_button "ログイン"
        expect(page).to have_content "ログインに失敗しました!"
      end

      it "登録されていないユーザーはログイン出来ない" do
        visit login_path
        fill_in "メールアドレス", with: "unknown@example.com"
        fill_in "パスワード", with: "unknown"
        click_button "ログイン"
        expect(page).to have_content "ログインに失敗しました!"
      end
    end
  end

  describe "headerの表示" do

    context "ログイン時" do
      it "headerに投稿とログアウトのlinkが表示されている" do
        User.create(@user_attributes);
        log_in(@user_attributes)
        within "#main-navbar" do
          expect(page).to have_link "投稿", href: "/posts/new"
          expect(page).to have_link "Logout", href: "/logout"
          expect(page).to have_css "#navbarDropdownMenuLink"
        end
      end  
    end

    context "ログインしてない時" do
      it "headerに正しくLoginとSignUpのlinkが表示されている" do
        visit root_path
        within "#main-navbar" do
          expect(page).to have_link "Login", href: "/login"
          expect(page).to have_link "SignUp", href: "/signup"
          expect(page).not_to have_css "#navbarDropdownMenuLink"
        end
      end  
    end
  
  end

  describe "ログアウト" do
    it "ログアウトすること", js: true do
      User.create(@user_attributes)
      log_in(@user_attributes)
      expect(page).to have_css "#navbarDropdownMenuLink"
      find("#navbarDropdownMenuLink").click
      page.accept_confirm { click_on 'Logout' }
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "ログアウトしました!"
    end
  end

end
