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
        visit root_path
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
          click_on "編集"
          fill_in name: "comment[body]", with: "更新コメントです"
          click_on "更新する"
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
        comment = FactoryBot.create(:comment, user:user, post:post) 
        visit post_path(post)
        within "#comment_#{comment.id}" do
          page.accept_confirm { click_on "削除" }
        end
        expect(page).to_not have_css("#comment_#{comment.id}")
      end

      it "他人のコメントは更新と削除のボタンが出ないこと" do
        comment = FactoryBot.create(:comment, user:user2, post:post) 
        visit post_path(post)
        within "#comment_#{comment.id}" do
          expect(page).to_not have_content "編集"
          expect(page).to_not have_content "削除"
        end
      end
    
    end
      
    context "ログインしていない状態" do
      let(:comment) { FactoryBot.create(:comment, user:user, post:post) }
      it "新規登録フォームが表示されないこと" do
        visit post_path(post)
        expect(page).to_not have_css("#form_comment")
      end

      it "更新と削除のボタンが出ないこと" do
        visit post_path(post)
        within "#comments" do
          expect(page).to_not have_content "編集"
          expect(page).to_not have_content "削除"          
        end
      end

    end

  end
  
end
