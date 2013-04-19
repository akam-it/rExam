class Answer < ActiveRecord::Base
  attr_accessible :question_id, :title, :is_correct
end
