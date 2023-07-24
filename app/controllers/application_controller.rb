# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login, except: [:not_authenticated]
  add_flash_types :primary, :success, :waring, :danger

  protected

  def guest_user_only
    redirect_to root_path if logged_in?
  end

  def not_authenticated
    redirect_to root_path, alert: t('controllers.application.not_authenticated.alert')
  end
end
