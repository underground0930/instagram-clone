require 'rails_helper'

RSpec.describe "Posts", type: :system do

  describe "投稿機能" do
    context "ログイン状態" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:user_attributes) { FactoryBot.attributes_for(:user)}
      before do
        log_in(user_attributes)
      end

      it "新規投稿が出来る" do
        within "#main-navbar" do
          click_link "投稿"          
        end
        expect(page).to have_current_path new_post_path
        fill_in name: "post[body]", with: "投稿内容のテスト"
        attach_file('post[images][]', [
          "#{Rails.root}/db/fixtures/dummy1.png", 
          "#{Rails.root}/db/fixtures/dummy2.png",
          "#{Rails.root}/db/fixtures/dummy3.png"
        ])
        click_button "新規投稿"
        expect(page).to have_content "投稿を作成しました"
        expect(page.all(".carousel-item").count).to eq 3
      end

      it "記事の更新が出来る" do
        post = FactoryBot.create(:post, user:user)
        visit edit_post_path(post)
        fill_in name: "post[body]", with: "本文の更新テキスト"
        attach_file('post[images][]',[
          "#{Rails.root}/db/fixtures/dummy1.png", 
          "#{Rails.root}/db/fixtures/dummy2.png"
        ])
        click_button "投稿を更新"
        expect(page).to have_content "投稿を更新しました"
        expect(page.all(".carousel-item").count).to eq 2
      end

      it "記事を削除出来る", js:true do
        post = FactoryBot.create(:post, user:user)
        visit post_path(post)
        page.accept_confirm { click_on "delete"}
        expect(page).to have_current_path posts_path
        expect(page).to have_content "投稿を削除しました"
      end
    
    end

    context "未ログイン状態" do

      it "新規投稿ページへ飛べずにトップにリダイレクト" do
        visit new_post_path
        expect(page).to have_content "ログインしてください"
      end

      it "投稿更新ページへ飛べずにトップにリダイレクト" do
        user = FactoryBot.create(:user)

        visit edit_post_path(user)
        expect(page).to have_content "ログインしてください"
      end

    end
  end

  describe "ページネーション" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post, user:user, created_at: Time.current.yesterday)}
    before do
      FactoryBot.create_list(:post, 15, user:user)
    end

    it "16件目は2ページ目に表示されること" do
      visit posts_path
      expect(page).to_not have_css("#carouselExampleIndicators_post_#{post.id}")
      visit posts_path(page: "2")
      expect(page).to have_css("#carouselExampleIndicators_post_#{post.id}")
    end

  end

  describe "投稿の検索機能", js: true do

    def search_posts(name, value)
      find("#search-addon").click
      fill_in name, with: value
      find("#post_search input[type='submit']").click
      expect(page).to have_no_selector('#exampleModal')
    end

    context "ログインしていない状態" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user2) }
      let!(:post) { FactoryBot.create(:post, user:user, body: "投稿1です。") }
      let!(:post2) { FactoryBot.create(:post, user:user2, body: "投稿2です。") }
      let!(:comment) { post2.comments.create(body: "コメント1です。", user:user2) }
        
      before do
        visit root_path
      end

      it "「投稿の本文」で検索が出来ること" do
        search_posts("q[body_cont]", post.body);
        targets = page.all(".post-child")
        expect(targets.count).to eq 1
        within targets[0] do
          expect(page).to have_content(post.body)
          expect(page).to have_link(href: "/posts/#{post.id}")
        end
      end

      it "「コメント」で検索が出来ること" do
        search_posts("q[comments_body_cont]", comment.body);
        targets = page.all(".post-child")
        expect(targets.count).to eq 1
        within targets[0] do
          expect(page).to have_content(post2.body)
          expect(page).to have_link(href: "/posts/#{post2.id}")
        end
      end

      it "「ユーザー」で検索が出来ること" do
        search_posts("q[user_username_cont]", user2.username);
        targets = page.all(".post-child")
        expect(targets.count).to eq 1
        within targets[0] do
          expect(page).to have_content(post2.body)
          expect(page).to have_link(href: "/posts/#{post2.id}")
        end
      end
    end

    context "ログインしている状態" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user2) }
      let!(:post) { FactoryBot.create(:post, user:user, body: "投稿1です。") }
      let!(:post2) { FactoryBot.create(:post, user:user2, body: "投稿2です。") }

      before do
        @user_attributes = FactoryBot.attributes_for(:user)
        log_in(@user_attributes)
        visit root_path
      end

      it "「投稿の本文」で自分の投稿の検索が出来ること" do
        search_posts("q[body_cont]", post.body);
        targets = page.all(".post-child")
        expect(targets.count).to eq 1
        within targets[0] do
          expect(page).to have_content(post.body)
          expect(page).to have_link(href: "/posts/#{post.id}")
        end
      end

      it "「投稿の本文」で他人の投稿はヒットしないこと" do
        search_posts("q[body_cont]", post2.body);
        targets = page.all(".post-child")
        expect(targets.count).to eq 0
      end
    end
  end

end
