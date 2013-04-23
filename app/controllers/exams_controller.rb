# -*- coding: utf-8 -*-

class ExamsController < ApplicationController
  def index
    @title = "Exams list"
    @exams = Exam.all
  end

  def show
    @exam = Exam.find(params[:id])
    @title = @exam.title
  end

  def prepare
    @title = "Choose settings"
    @exam = Exam.find(params[:id])
  end

  def start
    @exam = Exam.find(params[:id])
    @title = @exam.title
  end
end
