class Section < ActiveRecord::Base
  attr_accessible :exam_id, :title

  belongs_to :exam
  has_many :questions
end
