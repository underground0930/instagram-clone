require 'rails_helper'

RSpec.describe "Likes", type: :system do

  describe "いいね機能", js: true do
    let!(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post, user: user)}
    let!(:user_attributes) { FactoryBot.attributes_for(:user)}

    context "ログインした状態" do
      before do
        log_in(user_attributes)
      end
  
      it "TOP一覧の記事のいいねボタンを押して、正常にLikeとunLike出来ること" do
        within "#like_post_#{post.id}" do
          find(".btn-like").click
          expect(page).to have_css(".btn-unlike")
          find(".btn-unlike").click
          expect(page).to have_css(".btn-like")
        end
      end

      it "記事詳細のいいねボタンを押して、正常にLikeとunLike出来ること" do
        visit post_path(post)
        within "#like_post_#{post.id}" do
          find(".btn-like").click
          expect(page).to have_css(".btn-unlike")
          find(".btn-unlike").click
          expect(page).to have_css(".btn-like")
        end
      end
    
    end

    context "ログインしてない状態" do
      it "TOP一覧でいいねボタンが表示されない" do
        visit root_path
        expect(page).to_not have_css("#like_post_#{post.id}")
      end
      it "記事詳細でいいねボタンが表示されない" do
        visit root_path
        expect(page).to_not have_css("#like_post_#{post.id}")
      end
    end

  end
end
