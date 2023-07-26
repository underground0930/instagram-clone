# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  
  before_action :require_login, except: [:not_authenticated]
  add_flash_types :primary, :success, :waring, :danger

  protected

  def guest_user_only
    redirect_to root_path if logged_in?
  end

  def not_authenticated
    redirect_to root_path, danger: t('controllers.application.not_authenticated.alert')
  end
end
