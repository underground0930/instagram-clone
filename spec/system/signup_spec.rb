# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Signup", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "新規登録" do

    it "登録成功" do
      visit signup_path
      user_attributes = FactoryBot.attributes_for(:user)
      fill_in name: "user[username]",	with: user_attributes[:username] 
      fill_in name: "user[email]",	with: user_attributes[:email] 
      fill_in name: "user[password]", with: user_attributes[:password]
      fill_in name: "user[password_confirmation]", with: user_attributes[:password_confirmation]
      click_button "新規登録"

      expect(page).to have_current_path(root_path)
      expect(page).to have_content "ユーザー登録が完了しました"
    end

    it "登録失敗" do
      visit signup_path
      user_attributes = FactoryBot.attributes_for(:user)

      submit_and_count_errors

      fill_in name: "user[username]",	with: user_attributes[:username] 
      submit_and_count_errors

      fill_in name: "user[email]",	with: user_attributes[:email] 
      submit_and_count_errors

      fill_in name: "user[password]",	with: user_attributes[:password] 
      submit_and_count_errors

      fill_in name: "user[password_confirmation]",	with: user_attributes[:password_confirmation] 
      submit_and_count_errors
    end

  end

  def submit_and_count_errors
    click_button "新規登録"
    within ".alert.alert-danger" do
      expect(page.all('li').count).to_not eq 0
    end  
  end
end
