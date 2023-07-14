# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InstaCloneVer7
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # アプリケーション全体のデフォルトタイムゾーンを東京に設定します。
    config.time_zone = 'Tokyo'
    # ActiveRecordがデータベースとやり取りする際の時間データのタイムゾーンを設定します。
    # :localと設定すると、config.time_zoneで設定したローカルのタイムゾーン（ここでは東京）が使われます
    config.active_record.default_timezone = :local

    config.generators do |g|
      g.helper false
    end

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
