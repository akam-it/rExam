# -*- coding: utf-8 -*-

class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def edit
    @user = current_user
    @title = "Редактирование профиля"
  end

  def update
    @user = current_user
    if (params[:user][:password] != "" and params[:user][:password_confirmation] != "")
      if params[:user][:password] == params[:user][:password_confirmation]
        @user.password = params[:user][:password]
      else
        flash[:error] = "Пароль и подтверждение не совпадают. Пароль не изменен."
      end
    end
    if (params[:user][:password] != params[:user][:password_confirmation])
      flash[:error] = "Пароль и подтверждение не совпадают. Пароль не изменен."
    end
    @user.username = params[:user][:username]
    @user.email = params[:user][:email]
    @user.admin = params[:user][:admin]
    if @user.save
      redirect_to edit_user_path(@user), notice: "Пользователь '#{@user.username}' успешно обновлен."
    else
      #TODO: make checks
      redirect_to edit_user_path(@user), alert: "Пользователь не изменен."
    end
  end

  def show
    @title = "Профиль"
    @user = User.find_by_username(params[:username])

  end
end
