class Question < ActiveRecord::Base
  attr_accessible :allow_mix, :difficult, :exam_id, :explanation, :section_id, :title, :type_id

  belongs_to :type
  belongs_to :exam
  belongs_to :section
  has_many :answers
end
