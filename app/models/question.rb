class Question < ActiveRecord::Base
  attr_accessible :allow_mix, :difficult, :exam_id, :explanation, :section_id, :title, :type_id
end
