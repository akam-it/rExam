class Answer < ActiveRecord::Base
  attr_accessible :question_id, :title, :is_correct

  belongs_to :question

  validates_associated :question
  validates_presence_of :question
  validates :title, :presence => true,
            :length => { :minimum => 1 }
  validates :is_correct, :inclusion => {:in => [true, false]}

end
