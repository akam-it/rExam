class Exam < ActiveRecord::Base
  attr_accessible :category_id, :vendor_id, :description, :number, :pass_score, :time_limit, :title

  belongs_to :category
  belongs_to :vendor
  has_many :sections
  has_many :questions

  validates_associated  :category
  validates_presence_of :category
  validates_associated  :vendor
  validates_presence_of :vendor
  validates :number, :presence => true,
            :length => { :maximum => 50 }
  validates :pass_score, :presence => true,
            :numericality => { :only_integer => true, :greater_than => 100, :less_than => 9999 }
  validates :time_limit, :presence => true,
            :numericality => { :only_integer => true, :greater_than => 0, :less_than => 300 }
  validates :title, :presence => true,
            :length => { :minimum => 3 }
end
