class Question < ActiveRecord::Base
  attr_accessible :type_id, :exam_id, :section_id, :title, :allow_mix, :difficult, :explanation

  belongs_to :type
  belongs_to :section
  has_many   :results
  has_many   :answers, :dependent => :destroy

  validates_associated  :type
  validates_presence_of :type
#  validates_associated  :section
#  validates_presence_of :section
  validates :title, :presence => true,
            :length => { :minimum => 3 }
  validates :allow_mix, :inclusion => {:in => [true, false]}
  validates :difficult, :presence => true,
            :numericality => { :only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10 }
end
