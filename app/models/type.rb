class Type < ActiveRecord::Base
  attr_accessible :title

  has_many :questions

  validates :title, :presence => true,
            :length => { :minimum => 3 }
end
