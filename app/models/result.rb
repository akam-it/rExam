class Result < ActiveRecord::Base
  # answer may be string value or answer id or something else
  attr_accessible :answer, :question_id, :exam_id, :session_id, :user_id, :try, :is_correct, :score

  belongs_to   :question
end
