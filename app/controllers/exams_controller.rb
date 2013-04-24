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
    # Если параметр номера вопроса отсутствует - назначается 1
    if (!params[:question])
      params[:question] = 1
    end
    # Количество задаваемых вопросов - 30 или кол-во вопросов в экзамене
    qty = 30
    qty = @exam.questions.count if @exam.questions.count <= qty
    # Массив случайных id вопросов
    if (!session[:random_ids])
      session[:random_ids] = @exam.question_ids.sort_by { rand }.slice(0, qty)
    end
    @questions = Question.where(:id => session[:random_ids])
    # Текущий вопрос, если неверно указан, то -  или первый или последний
    @current_que = params[:question].to_i
    @current_que = 1 if @current_que <= 0
    @current_que = @questions.count if @current_que > @questions.count
    # Заголовок
    @title = @exam.title
  end
end
