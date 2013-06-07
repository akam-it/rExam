# -*- coding: utf-8 -*-
#
class Exam < ActiveRecord::Base
  attr_accessible :category_id, :vendor_id, :title, :description, :number, :version, :pass_score, :time_limit
  after_save :add_default_section

  belongs_to :category
  belongs_to :vendor
  has_many :sections, :dependent => :destroy
  has_many :questions, :through => :sections
  has_many :answers, :through => :questions

  validates_associated  :category
  validates_presence_of :category
  validates_associated  :vendor
  validates_presence_of :vendor
  validates :title, :presence => true,
            :length => { :minimum => 3 }
  validates :number, :presence => true,
            :length => { :maximum => 50 }
  validates :version, :presence => true,
            :length => { :maximum => 50 }
  validates :pass_score, :presence => true,
            :numericality => { :only_integer => true, :greater_than => 10, :less_than => 9999 }
  validates :time_limit, :presence => true,
            :numericality => { :only_integer => true, :greater_than => 0, :less_than => 300 }

  private

  def add_default_section
    n = self.sections.new :title => "Общая"
    n.save!
  end
end
