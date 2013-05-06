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
    session[:answer] = []
    session[:random_ids] = []
    @title = "Choose settings"
    @exam = Exam.find(params[:id])
    # Количество задаваемых вопросов - 30 или кол-во вопросов в экзамене
    qty = 30
    qty = @exam.questions.count if @exam.questions.count <= qty
    # Массив случайных id вопросов
    if (!session[:random_ids].present?)
      session[:random_ids] = @exam.question_ids.sort_by { rand }.slice(0, qty)
      session[:qty] = qty
    end
    # Попытки
    if !session[:try].present?
      session[:try] = 1
    else
      session[:try] += 1
    end
  end

  def answer
    # TODO: check parameters
    current_que = params[:question].to_i
    answer = params[:answer].to_i
    session[:answer][current_que] = answer
  end

  def start
    @exam = Exam.find(params[:id])
    # Если параметр номера вопроса отсутствует - назначается 1
    if (!params[:question].present?)
      params[:question] = 1
    end
    # Текущий вопрос, если неверно указан, то -  или первый или последний
    @current_que = params[:question].to_i
    @current_que = 1 if @current_que <= 0
    @current_que = session[:qty] if @current_que > session[:qty]
    # Заголовок
    @title = @exam.title
    @question = Question.find(session[:random_ids][@current_que-1])
    @answers = @question.answers
    @answers.shuffle! if @question.allow_mix?
  end

  def finish
    @exam = Exam.find(params[:id])
    @title = "Результаты тестирования"
    @questions = Question.where(:id => session[:random_ids])
    @score = 0
    @score_max = 0
    @questions.each do |q|
      @score_max += q.difficult
    end
    @correctCount = 0
    r = Result.where(:session_id => session[:session_id], :user_id => 0, :exam_id => params[:id], :try => session[:try])
    if r.count > 0
      @result = r
      flash[:notice] = "Попытка повторной вставки результатов"
      @score = session[:score]
      @correctCount = session[:correctCount]
    else
      session[:random_ids].each_with_index do |id, index|
        try = session[:try]
        answer = session[:answer][index+1]
        isCorrect = (Question.find(id).answers.where(:is_correct => true)[0].id == answer.to_i)
        score = isCorrect ? Question.find(id).difficult : 0
        @score += score
        @correctCount += 1 if isCorrect
        result = Result.new(:session_id => session[:session_id], :user_id => 0, :exam_id => params[:id], :try => try, :question_id => id, :answer => answer, :is_correct => isCorrect, :score => score)
        result.save!
      end
      session[:score] = @score
      session[:correctCount] = @correctCount
      @result = Result.where(:session_id => session[:session_id], :user_id => 0, :exam_id => params[:id], :try => session[:try])
    end
    @isPass = @score >= @exam.pass_score
  end
end
