class Vendor < ActiveRecord::Base
  attr_accessible :title

  has_many  :exams, :dependent => :restrict

  validates :title, :presence => true,
            :length => { :minimum => 2 }
end
