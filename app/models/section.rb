class Section < ActiveRecord::Base
  attr_accessible :exam_id, :title

  belongs_to :exam
  has_many :questions

  validates_associated  :exam
  validates_presence_of :exam
  validates :title, :presence => true,
            :length => { :minimum => 3 }
end
