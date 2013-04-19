class Category < ActiveRecord::Base
  attr_accessible :title

  has_ancestry
  has_many :exams
end
