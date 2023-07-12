# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Samples', type: :system) do
  describe 'Capybaraの疎通確認用' do
    it 'ページが開ける' do
      visit '/'
      expect(page).to have_content 'テストです'
    end
  end
end
