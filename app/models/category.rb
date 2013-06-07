class Category < ActiveRecord::Base
  attr_accessible :title, :parent_id

  has_ancestry
  has_many :exams, :dependent => :restrict

  validates :title, :presence => true,
            :length => { :minimum => 2 }
end
