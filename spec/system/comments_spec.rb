require 'rails_helper'

RSpec.describe "Comments", type: :system do

  describe "コメント機能", js:true do
    let!(:user) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user2) }
    let!(:post) { FactoryBot.create(:post, user:user) }
    let!(:user_attributes) { FactoryBot.attributes_for(:user)}

    context "ログインした状態" do
      before do
        log_in(user_attributes)
      end

      it "新規登録出来ること" do
        visit post_path(post)
        within "#form_comment" do
          fill_in name: "comment[body]", with: "新規コメント"
          click_button "登録する"
        end
        target = page.all("#comments li").last
        expect(target).to have_content "新規コメント"
        expect(target).to have_content user.username
      end
  
      it "自分のコメントは更新が出来ること" do
        comment = FactoryBot.create(:comment, user:user, post:post) 
        visit post_path(post)
        within "#comment_#{comment.id}" do
          click_button "編集"
          fill_in name: "comment[body]", with: "更新コメントです"
          click_button "更新する"
          expect(page).to have_content "更新コメントです"
        end
      end

      it "テキストエリアが空のまま登録を押すとエラーが出ること" do
        visit post_path(post)
        within "#form_comment" do
          click_button "登録する"
          expect(page).to have_content "Bodyを入力してください"
        end
      end
  
      it "自分のコメントは削除が出来ること" do
      end

      it "他人のコメントは更新と削除のボタンが出ないこと" do
      end
    
    end
      
    # context "ログインしていない状態" do
    #   it "新規登録フォームが表示されないこと" do

    #   end

    #   it "更新と削除のボタンが出ないこと" do
    #   end

    # end

  end
  
end
