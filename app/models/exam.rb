class Exam < ActiveRecord::Base
  attr_accessible :category_id, :description, :number, :pass_score, :time_limit, :title
end
