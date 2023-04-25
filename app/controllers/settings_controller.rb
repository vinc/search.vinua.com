# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def allow
    domain = params[:domain]
    if domain.present?
      current_user.blocked_domains.delete(domain)
      current_user.update(blocked_domains: current_user.blocked_domains.uniq.sort)
    end
    redirect_back(fallback_location: settings_path)
  end

  def block
    domain = params[:domain]
    if domain.present?
      current_user.blocked_domains.push(domain)
      current_user.update(blocked_domains: current_user.blocked_domains.uniq.sort)
    end
    redirect_back(fallback_location: settings_path)
  end
end
