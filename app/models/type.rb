class Type < ActiveRecord::Base
  attr_accessible :title

  has_many :questions, :dependent => :restrict

  validates :title, :presence => true,
            :length => { :minimum => 3 }
end
