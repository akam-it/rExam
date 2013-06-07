# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def verify_is_admin
    authenticate_user!
    if current_user.admin
      return
    else
      flash[:error] = "Требуются администраторские права"
      redirect_to root_path
    end
  end
end
