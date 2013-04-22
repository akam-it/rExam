class Category < ActiveRecord::Base
  attr_accessible :title

  has_ancestry
  has_many :exams

  validates :title, :presence => true,
            :length => { :minimum => 3 }
end
