# -*- coding: utf-8 -*-

class CategoriesController < ApplicationController

def index
  @title = "Список категорий"
  respond_to do |format|
    format.html # index.html.erb
    format.json { render json: CategoriesDatatable.new(view_context) }
  end
end

def edit
  @title = "Редактировать категорию"
  @category = Category.find(params[:id])
end

def update
  @category = Category.find(params[:id])
  respond_to do |format|
    if @category.update_attributes(params[:category])
      format.html { redirect_to categories_url, notice: "Категория '#{@category.name}' успешно обновлена." }
      format.json { head :no_content }
    else
      format.html { render action: "edit" }
      format.json { render json: @category.errors, status: :unprocessable_entity }
    end
  end
end

def new
  @title = "Новая категория"
  @category = Category.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
end

def create
  @category = Category.new(params[:category])
  @categories = Category.where("parent_id is NULL")
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_url, notice: "Категория '#{@category.name}' успешно добавлена." }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        #format.json { render json: @category.errors, status: :unprocessable_entity }
        format.json { render json: @categories }
      end
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
  respond_to do |format|
    format.html { redirect_to categories_url }
    format.json { head :no_content }
  end
end



# Class end
end

