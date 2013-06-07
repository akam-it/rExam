# -*- coding: utf-8 -*-

class Admin::ExamsController < ApplicationController
  before_filter :verify_is_admin

  def index
    @title = "Список экзаменов"
    @exams = Exam.all
  end

  def edit
    @exam = Exam.find(params[:id])
    @title = @exam.title
    @sections = @exam.sections
    @questions = @exam.questions.order("id")
    if (!params[:question].present? and @exam.questions.size > 0)
      params[:question] = @exam.questions.first.id
    end
    if params[:question] == "new"
      @question = Question.new
      @question.id = 0
    else
      @question = Question.find(params[:question]) if params[:question].present?
    end
    @answers = @question.answers if !@question.nil?
    @categories = Category.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
      }.sort {|x,y| x.ancestry <=> y.ancestry
      }.map{ |c| ["-" * (c.depth - 1) + c.title,c.id]
      }.unshift(["-- none --", nil])
  end

  def update
    if params[:exam].present?
    # Обновляем информацию об экзамене
      @exam = Exam.find(params[:id])
      if @exam.update_attributes(params[:exam])
        flash[:notice] = "Экзамен успешно обновлен."
      else
        #TODO: make checks
        flash[:alert] = "Экзамен не изменен."
      end
    else
      # Обновляем информацию о вопросе и ответах
      if params[:id] == "0"
        @question = Question.new
      else
        @question = Question.find(params[:id])
      end
      @question.update_attributes(params[:question])
      @question.title = params[:title]
      @question.allow_mix = params[:allow_mix]
      @question.section_id = params[:section]
      @question.difficult = params[:difficult]
      @question.type_id = params[:type]
      @question.explanation = params[:explanation]
      @question.save

      # Изменяю измененные ответы
      if params[:id] != "0"
      if params[:answer].present?
      params[:answer].each do |id,title|
        a = Answer.find(id)
        a.title = title
        if params[:correct_answer].include? id
          a.is_correct = true
        else
          a.is_correct = false
        end
        a.save
      end
      end
      # Удаляю убранные ответы
      if @question.answer_ids.size > 0
      (@question.answer_ids - (params[:answer].map { |a| a[0].to_i })).each do |id|
        Answer.find(id).destroy
      end
      end
      # Добавляю новые ответы
      if params[:new_answer].present?
        params[:new_answer].each do |title|
          a = Answer.new
          a.title = title
          a.question_id = @question.id
          a.save
        end
      end
      end
    end

    puts "AAA= #{Section.find(params[:section].to_i).exam}"

    redirect_to edit_admin_exam_path(Section.find(params[:section].to_i).exam)+"?question="+@question.id.to_s
  end

  def new
    @title = "Новый экзамен"
    @exam = Exam.new
    @categories = Category.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
      }.sort {|x,y| x.ancestry <=> y.ancestry
      }.map{ |c| ["-" * (c.depth - 1) + c.title,c.id]
      }.unshift(["-- Выберите --", nil])
  end

  def create
    @exam = Exam.new(params[:exam])
    @categories = Category.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
      }.sort {|x,y| x.ancestry <=> y.ancestry
      }.map{ |c| ["-" * (c.depth - 1) + c.title,c.id]
      }.unshift(["-- Выберите --", nil])
    if @exam.save
      redirect_to admin_exams_path, notice: "Экзамен '#{@exam.title}' успешно добавлен."
    else
      #TODO: make checks
      render action: "new", alert: "Экзамен не добавлен. #{e.message}"
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    begin
      @exam.destroy
      flash[:notice] = "Экзамен удален"
    rescue Exception => e
      flash[:notice] = e.message
    end
    redirect_to admin_exams_path
  end

  def destroy_question
    @question = Question.find(params[:id])
    @exam = @question.section.exam_id
    begin
      @question.destroy
      flash[:notice] = "Вопрос удален"
    rescue Exception => e
      flash[:notice] = e.message
    end
    redirect_to :back
  end



  def import_form
    @title = "Импорт экзамена"
  end

  def import_prepare
    @title = "Импорт экзамена"
    @headers = true
    @vceFile = params[:vceFile].tempfile

    getHeaders
  end

  def import
    @vceFile = params[:vceFile]

    getHeaders
  end



private

def getHeaders
  @debug = 1
  @sections = []
  @exams = []
  @questions = []
  @answers = []


  # Поля заголовка. Очередность важна
  fields = [
    [:format_type, 2],
    [:format_version, 2],
    [:exam_type, 1],
    [:exam_number,nil],
    [:exam_title, nil],
    [:exam_passcore, 4],
    [:exam_timelimit, 4],
    [:exam_version, nil],
    [:create_date, 12],
    [:modify_date, 12],
    [:show_desc, 18],
    [:exam_description, nil],
    [:section_qty, 4],
    [:exams_count, 1],
  ]

  @vce = {}
  @time_null = 0x7c52a640

  open(@vceFile) do |f|
    # File size
    @vce[:file_size_real] = f.size
    f.seek(-12, File::SEEK_END)
    @vce[:file_size] = f.read(4).reverse.unpack('H*')[0].to_i(16)
    abort "Incorrect file size or file format" if @vce[:file_size_real] != @vce[:file_size]
    # CRC
    f.seek(0)
    @vce[:crc] = Zlib::crc32( f.read(@vce[:file_size] - 8) ).to_s(16).scan(/.{1,2}/).reverse.join.to_i(16)
    f.seek(0)

    fields.each do |field, size|
      case field
      when :format_type
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos).to_s(16)}" % [field, size] if @debug >= 1
        data = f.read(size).unpack('H*')[0]
        abort "Error: File format is NOT VCE" if data != "85a8"
        @vce[field] = data

      when :format_version
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos).to_s(16)}" % [field, size] if @debug >= 1
        data = f.read(size).unpack('H*')[0]
        abort "Error: Unknown file format version. I can proccessing only 0201 version" if data != "0201"
        @vce[field] = data

      when :create_date
        # http://dan.drydog.com/unixdatetime.html
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos).to_s(16)}" % [field, size] if @debug >= 1
        unix_time = f.read(size-8).reverse.unpack('H*')[0].to_i(16)
        time_only = unix_time % (60*60*24)
        f.pos += 4
        create_time = f.read(4).reverse.unpack('H*')[0].to_i(16)
        unix_time = create_time - @time_null + unix_time + calcGMT(time_only)
        abort "File is broken at field #{field}! Position = 0x#{(f.pos).to_s(16)}" if f.read(4).unpack('H*') != ["ffffffff"] # время создания и изменения разделяется 4 байтами FF
        @vce[field] = Time.at(unix_time).utc.strftime("%d.%m.%Y %H:%M")

      when :modify_date
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos).to_s(16)}" % [field, size] if @debug >= 1
        unix_time = f.read(size-8).reverse.unpack('H*')[0].to_i(16)
        time_only = unix_time % (60*60*24)
        f.pos += 4
        modify_time = f.read(4).reverse.unpack('H*')[0].to_i(16)
        unix_time = modify_time - @time_null + unix_time + calcGMT(time_only)
        abort "File is broken at field #{field}! Position = 0x#{(f.pos).to_s(16)}" if f.read(4).unpack('H*') != ["ffffffff"] # после времени изменения - 4 байта FF
        @vce[field] = Time.at(unix_time).utc.strftime("%d.%m.%Y %H:%M")
        @vce[:modify_date_raw] = unix_time

	      when :exam_passcore
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos).to_s(16)}" % [field, size] if @debug >= 1
        data = f.read(size).reverse.unpack('H*')[0].to_i(16)
        @vce[field] = data

      when :exam_timelimit
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos).to_s(16)}" % [field, size] if @debug >= 1
        data = f.read(size).reverse.unpack('H*')[0].to_i(16)
        @vce[field] = data

      when :show_desc
        @desc_jump = 0
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos).to_s(16)}" % [field, size] if @debug >= 1
        show_flag = f.read(1).unpack('C')[0]
        f.pos += 5 # (SD) 00 00 00 00 00   (08 00 00 00)      00 01 02 03 ......
        @desc_jump = f.read(4).reverse.unpack('H*')[0].to_i(16) # кол-во байт до начала размера описания экзамена
        f.pos += @desc_jump # перепрыгиваем на начало размера описания экзамена
        @vce[field] = show_flag

      when :exam_description
        # TODO: не показывает русский
        puts "\tSTART exam_description analyze... Desc_pos = +#{@desc_jump} Pos = 0x#{f.pos.to_s(16)}" if @debug >= 1
        size = (f.read(4).reverse.unpack('H*')[0].to_i(16)-25) # определяем размер поля (23 - байты от размера до описание. 2 - после описания всегда два завершающих байта 30 3a)
        puts "\t  Size of %s = %d, Begin position = 0x#{(f.pos-4).to_s(16)}" % [field, size] if @debug >= 1
        f.pos += 23 # TODO: для чего эти 23 байт? ВСЕГДА 2d 39 22 32 24 36 26 36 05 03 3a 2b 3d 2d 2f 28 31 22 33 24 18 1c
        data = f.read(size).unpack('C*')
        puts "\t  Descr. codes = #{data}" if @debug >= 2
        @vce[:exam_description] = encode2(data)
        f.pos += 2 # TODO: для чего эти 2 байта?
        # abort "File is broken at field #{field}! Position = 0x#{(f.pos).to_s(16)}" if f.read(2).unpack('H*') != ["303a"] # после размера поля должно быть 303a
        # 4-байтное число через 5 байтов после поля show_desc - это desc_jump кол-во байт, через которое будет размер описания экзамена
        # далее следует это самое desc_jump кол-во байт, включая 25 байт.
        # далее идет описание и заканчивается 303a. Оказывается не всегда заканичвается на 303a

      when :section_qty
        data = f.read(4).reverse.unpack('H*')[0].to_i(16)
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos-4).to_s(16)}" % [field, size] if @debug >= 1
        @vce[field] = data
        if (data > 0)
          # если секций больше нуля
          data.times do |c|
            section_num = f.read(4).reverse.unpack('H*')[0].to_i(16) # TODO: Если секций нуль, то эти 4 байта это кол-во экзаменов. если секции имеются, то это номер текущей секции
            section_size = f.read(4).reverse.unpack('H*')[0].to_i(16)-2
            f.pos += 2 # пропускаю FF FF
            section_data = f.read(section_size).unpack('C*')
            @sections << { :id => section_num, :title => encode1(section_data) }
          end
        end
        puts "\t  Sections end at 0x#{(f.pos).to_s(16)}" if @debug >= 1

      when :exams_count
        exams_count = f.read(4).reverse.unpack('H*')[0].to_i(16)
        puts "\tSize of %s = %d, Begin position = 0x#{(f.pos-4).to_s(16)}" % [field, size] if @debug >= 1
        @vce[field] = exams_count
        @vce[:questions_count] = 0

        if (exams_count > 0)
	  next if @headers
          # если экзаменов больше нуля
          exams_count.times do |e|
            f.pos += 1 # TODO: что за байт?.
            exam_title_size = f.read(4).reverse.unpack('H*')[0].to_i(16)-2
            f.pos += 2 # пропускаю FF FF
            exam_data = f.read(exam_title_size).unpack('C*')
            @exams << { :id => e+1, :title => encode1(exam_data) }
            questions_count = f.read(4).reverse.unpack('H*')[0].to_i(16)
            puts "\tQuestions count in this exam = #{questions_count} Pos = #{f.pos}" if @debug >= 1
            if questions_count > 0
              questions_count.times do |q|
                que_start = f.pos
                @vce[:questions_count] += 1
                puts "\t  Question #{q+1}. Position = 0x#{(f.pos).to_s(16)}" if @debug >= 1
                que_size = f.read(4).reverse.unpack('H*')[0].to_i(16) # общий размер вопроса
                que_type = f.read(1).unpack('C*')[0] # тип вопроса/ответа
                que_section_id = f.read(4).reverse.unpack('H*')[0].to_i(16); que_section_id = 0 if que_section_id == 0xffffffff # принадлежность к секции
                que_difficult = f.read(4).reverse.unpack('H*')[0].to_i(16) # сложность вопроса
                case que_type
                  when 0
                  # Множественный выбор (один ответ) (+ с описанием ситуации)
                    f.pos += 4 # Пропускаем нули
                    answers_start = f.pos
                    puts "\t    QuestionSize = 0x#{(que_size).to_s(16)}  Position = 0x#{(f.pos).to_s(16)}" if @debug >= 1
                    # размер данных всех ответов вопроса до служебных полей correct_answers_count и т.п.
                    answers_total_size = f.read(4).reverse.unpack('H*')[0].to_i(16) # растояние до техн. данных вопроса (кол-во верных ответов, верные ответы, если есть, кол-во ответов)
                    que_title_size = (f.read(4).reverse.unpack('H*')[0].to_i(16) ^ 0x03020100) - 25  # размер заголовка вопроса
                    f.pos += 23
                    que_title = f.read(que_title_size).unpack('C*')

                    # -----------------------------------------------------------#
                    # Идем за служебными данными (нахрена они их назад запихнули!)
                    f.pos = answers_start + answers_total_size + 4;
                    correct_answers_count = f.read(4).reverse.unpack('H*')[0].to_i(16);
                    correct_answers = f.read(correct_answers_count).unpack('C*')
                    answers_count = f.read(4).reverse.unpack('H*')[0].to_i(16)
                    allow_mix = f.read(1).unpack('C')[0]
                    f.pos = answers_start + 4
                    # ^^^ Возвращаемся на исходную и продолжаем парсить ответы
                    # -----------------------------------------------------------#

                    f.pos = answers_start + 8 + 23 + que_title_size
                    answers_count.times do |a|
                      start = f.pos
                      ans_key = f.read(2).reverse.unpack('H*')[0].to_i(16) # Нифига это не ключ.. игнорирую..
                      answer_title_size_raw = f.read(4).reverse.unpack('H*')[0].to_i(16)
                      puts "#{a+1}. KEY = 0x%04x   SIZE_RAW = 0x%08x   QUE_TITLE_SIZE = %d  POS = 0x#{((f.pos)-6).to_s(16)}" % [ans_key, answer_title_size_raw, que_title_size]
                      que_key = 0x01010101 * (que_title_size % 256)
                      ans_null = ( 0x201f1e1d + (0x1d1d1d1d * a) + (0x01010101 * (que_title_size % 256) ) )
                      puts "ANS_NULL = (0x201f1e1d + (0x1d1d1d1d * #{a}) + (0x01010101 * (#{que_title_size} % 256))) = 0x#{ans_null.to_s(16)}"
                      a.times do |x|
                        ans_null += (0x01010101 * ( @answers[x][:answer_title_size] % 256) )
                        puts "ANS_NULL += 0x01010101 * ( #{@answers[x][:answer_title_size]} % 256 )= 0x#{ans_null.to_s(16)}"
                      end
                      while ans_null > 0xffffffff
                        diff = 0xffffffff - que_key
                        ans_null = ans_null - 0xffffffff - 0x01010101
                        puts "\tANS_NULL = 0x#{ans_null.to_s(16)} - 0xffffffff - 0x01010101 = 0x#{ans_null.to_s(16)}"
                      end
                      answer_title_size = (answer_title_size_raw ^ ans_null) - 25
                      puts "FORMULA = 0x#{answer_title_size_raw.to_s(16)} ^ 0x#{ans_null.to_s(16)} = #{answer_title_size}\n\n"
                      f.pos += 23 # TODO: что за опять 23 байта????
                      answer_title = encode2(f.read(answer_title_size).unpack('C*'))
                      @answers << { :question_id => q+1, :answer_id => a+1, :title => answer_title, :size_raw => answer_title_size_raw, :answer_title_size => answer_title_size, :start_at => start }
                    end
                    f.pos += 13
                    jump = que_start + que_size - f.pos + 4; f.pos += jump
                    @questions << { :id => @vce[:questions_count], :question_id => q+1, :exam_id => e+1, :title => encode2(que_title), :type => que_type, :section_id => que_section_id, :difficult => que_difficult, :correct_answers_count => correct_answers_count, :answers_count => answers_count, :correct_answers => correct_answers, :allow_mix => allow_mix, :size => que_size, :title_size => que_title_size, :answers_total_size => answers_total_size, :answers_start_at => answers_start, :answers_tech_data => answers_start + answers_total_size + 4 }
                  when 1
                    puts "\t    QuestionSize = #{que_size}  Position = 0x#{(f.pos).to_s(16)}" if @debug >= 1
                    f.pos += 11 # TODO: какие-то данные
                    que_title_size = f.read(1).unpack('H*')[0].to_i(16) - 25 # размер заголовка вопроса
                    f.pos += 26
                    que_title = f.read(que_title_size).unpack('C*')
                    f.pos += 155
                    allow_mix = f.read(1).unpack('C')[0]
                    puts "aaa1 = 0x#{(f.pos).to_s(16)}"
                    verify_checked_count = f.read(1).unpack('C')[0]
                    f.pos += que_size - que_title_size - 44 - 157
                    puts "bbb1 = 0x#{(f.pos).to_s(16)}"
                    @questions << { :id => c+1, :title => encode2(que_title), :type => que_type, :section_id => que_section_id, :difficult => que_difficult, :allow_mix => allow_mix, :verify_checked_count => verify_checked_count, :size => que_size }
                  # Множественный выбор (несколько ответов) (+ с описанием ситуации)
                  #when 2
                  # Выбрать и переместить
                  #when 3
                  # Прицелиться и выбрать
                  #when 4
                  # Создать дерево
                  #when 5
                  # Пересортировать список
                  #when 6
                  # нет такого типа?
                  #when 7
                  # Бросить и соединить
                  #when 8
                  # Заполнить поле
                  #when 9
                  # Горячая область
                  else
                    f.pos += que_size - 1 - 4 - 1
                    @questions << { :id => c+1, :type => que_type, :section_id => que_section_id, :difficult => que_difficult, :size => que_size }
                end
              end
            end
          end
        end



      else
        if size != nil
        # exam_type
          data = f.read(size).unpack('H*')[0]
          puts "\tSize of %s = %d, Begin position = 0x#{(f.pos-size).to_s(16)}" % [field, size] if @debug >= 1
          @vce[field] = data
        elsif size == nil
        # exam_number, exam_version, exam_title (encode1)
          size = f.read(4).reverse.unpack('H*')[0].to_i(16)-2 # определяем размер поля
          abort "File is broken at field #{field}! Position = 0x#{(f.pos).to_s(16)}" if f.read(2).unpack('H*') != ["ffff"] # после размера поля должно быть FFFF
          puts "\tSize of %s = %d, Begin position = 0x#{(f.pos).to_s(16)}" % [field, size] if @debug >= 1
          data = f.read(size).unpack('C*')
          @vce[field] = encode1(data)
	      end

      end
    end
    if !@headers
      @sect_ids = []
      @answ_ids = []
      @ques_ids = []
      new_exam = Exam.new(:title => @vce[:exam_title], :number => @vce[:exam_number], :description => @vce[:description], :version => @vce[:exam_version], :pass_score => @vce[:exam_passcore], :time_limit => @vce[:exam_timelimit], :vendor_id => 1, :category_id => 1)
      new_exam.save!
      @exam = new_exam
      @sect_ids << new_exam.sections.first.id
      @sections.each do |s|
        new_sec = new_exam.sections.new :title => s[:title]
        new_sec.save!
        @sect_ids << new_sec.id
      end
      @questions.each do |q|
        new_que = new_exam.questions.new(:title => q[:title], :type_id => q[:type]+1, :difficult => q[:difficult], :allow_mix => q[:allow_mix], :explanation => q[:explanation], :section_id => @sect_ids[q[:section_id]])
        new_que.save!
        @ques_ids << new_que.id
      end
      @answers.each do |a|
        new_ans = Answer.new(:question_id => @ques_ids[a[:question_id]-1], :title => a[:title])
        new_ans.is_correct = @questions[a[:question_id]-1][:correct_answers].include? a[:answer_id]+64
        new_ans.save!
      end
    end
  end


end

def calcGMT(value)
  # принимает десятичное число (время)
  # возвращает десятичное число GMT
  time = 86400 - value
  to_return = -1 * time if time > 43200
  to_return = time if time < 42300
  to_return = 0 if time == 0
  return to_return
end

def encode1(value)
  # Принимает массив десятичных значений
  # Возвращает строку, образованную посимвольно C ^ index
  # декодирует заголовок, номер, версию экзамена
  to_return = ""
  value.each_with_index do |byte, i|
    to_return += (byte ^ i).chr
  end
  to_return
end

def encode2(array)
  # Принимает массив десятичных значений
  # Возвращает строку, образованную посимвольно C ^ (C_key - 1)
  # декодирует описание экзамена
  to_return = ""
  (0..array.length-1).step(2) do |i|
    array[i+1] = 256 if (array[i+1] == 0)
    to_return += (array[i] ^ (array[i+1] - 1)).chr
  end
  to_return
end


end
