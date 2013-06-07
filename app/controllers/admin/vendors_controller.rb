# -*- coding: utf-8 -*-

class Admin::VendorsController < ApplicationController
  before_filter :verify_is_admin

  def index
    @title = "Список категорий"
    @vendors = Vendor.all
  end

  def edit
    @vendor = Vendor.find(params[:id])
    @title = "Редактирование категории"
  end

  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update_attributes(params[:vendor])
      redirect_to admin_vendors_path, notice: "Категория '#{@vendor.title}' успешно обновлена."
    else
      #TODO: make checks
      redirect_to edit_admin_vendor_path(@vendor), alert: "Категория не изменена."
    end
  end

  def new
    @title = "Новая категория"
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(params[:vendor])
    if @vendor.save
      redirect_to admin_vendors_path, notice: "Категория '#{@vendor.title}' успешно добавлена."
    else
      #TODO: make checks
      render "edit", alert: "Категория не добавлена."
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    begin
      @vendor.destroy
      flash[:notice] = "Категория удалена"
    rescue Exception => e
      flash[:notice] = e.message
    end
    redirect_to admin_vendors_path
  end
end
