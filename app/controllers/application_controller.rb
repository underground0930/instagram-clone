# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :require_login, except: [:not_authenticated]
  add_flash_types :primary, :success, :waring, :danger

  protected

  def not_authenticated
    redirect_to root_path, alert: 'Please login first.'
  end

end
