# frozen_string_literal: true

class HealthChecksController < ApplicationController
  def show
    head :ok
  end
end
