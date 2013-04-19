class Exam < ActiveRecord::Base
  attr_accessible :category_id, :description, :number, :pass_score, :time_limit, :title

  belongs_to :category
  has_many :sections
  has_many :questions
end
