# -*- coding: utf-8 -*-

class Admin::UsersController < ApplicationController
  before_filter :verify_is_admin

  def index
    @title = "Список пользователей"
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
    @title = "Редактирование пользователя"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path, notice: "Пользователь '#{@user.username}' успешно обновлен."
    else
      #TODO: make checks
      redirect_to edit_admin_user_path(@user), alert: "Пользователь не изменен."
    end
  end

  def new
    @title = "Новый пользователь"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_users_path, notice: "Пользователь '#{@user.username}' успешно добавлен."
    else
      #TODO: make checks
      render "edit", alert: "Пользователь не добавлен."
    end
  end

  def destroy
    @user = User.find(params[:id])
    begin
      @user.destroy
      flash[:notice] = "Пользователь удален"
    rescue Exception => e
      flash[:notice] = e.message
    end
    redirect_to admin_users_path
  end
end
