# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('HealthChecks', type: :request) do
  describe 'ヘルスチェック' do
    it '200のHTTPステータスが返る' do
      get '/health_check'
      expect(response).to have_http_status :ok
    end
  end
end
