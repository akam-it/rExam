class Vendor < ActiveRecord::Base
  attr_accessible :title

  has_many  :exams

  validates :title, :presence => true,
            :length => { :minimum => 3 }
end
