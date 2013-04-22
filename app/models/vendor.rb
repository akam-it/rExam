class Vendor < ActiveRecord::Base
  attr_accessible :title

  validates :title, :presence => true,
            :length => { :minimum => 3 }
end
