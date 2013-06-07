# -*- coding: utf-8 -*-

class Admin::CategoriesController < ApplicationController
  before_filter :verify_is_admin

  def index
    @title = "Список категорий"
    @categories = Category.all
  end

  def edit
    @categories = Category.all(:conditions => ["id != ?", params[:id]]).each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
      }.sort {|x,y| x.ancestry <=> y.ancestry
      }.map{ |c| ["-" * (c.depth - 1) + c.title,c.id]
      }.unshift(["-- none --", nil])
    @category = Category.find(params[:id])
    @title = "Категория " + @category.title
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to admin_categories_path, notice: "Категория '#{@category.title}' успешно обновлена."
    else
      #TODO: make checks
      redirect_to edit_admin_category_path(@category), alert: "Категория не изменена."
    end
  end

  def new
    @title = "Новая категория"
    @category = Category.new
    @categories = Category.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
      }.sort {|x,y| x.ancestry <=> y.ancestry
      }.map{ |c| ["-" * (c.depth - 1) + c.title,c.id]
      }.unshift(["-- none --", nil])
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to admin_categories_path, notice: "Категория '#{@category.title}' успешно добавлена."
    else
      #TODO: make checks
      redirect_to new_admin_category_path, alert: "Категория не добавлена."
    end
  end

  def destroy
    @category = Category.find(params[:id])
    begin
      @category.destroy
      flash[:notice] = "Категория удалена"
    rescue Exception => e
      flash[:notice] = e.message
    end
    redirect_to admin_categories_path
  end
end
