# -*- coding: utf-8 -*-

class Admin::SectionsController < ApplicationController
  before_filter :verify_is_admin

  def update
    @exam = Exam.find(params[:exam_id])
    puts params
    # Сохраняю измененные секции
    if params[:section].present? and params[:section].size >= 1
      params[:section].each do |id, title|
        a = Section.find(id)
        a.title = title
        a.save!
      end
    end
    # Удаляю убранные секции
    if @exam.section_ids.size > 0
      (@exam.section_ids - (params[:section].map { |a| a[0].to_i })).each do |id|
        Section.find(id).destroy
      end
    end
    # Добавляю новые секции
    if params[:new_section].present?
      params[:new_section].each do |title|
        a = Section.new
        a.title = title
        a.exam = @exam
        a.save!
      end
    end

    redirect_to edit_admin_exam_path(@exam)
  end

end
