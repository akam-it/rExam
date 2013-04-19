class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :category_id
      t.string :title
      t.string :number
      t.integer :pass_score
      t.integer :time_limit
      t.string :description

      t.timestamps
    end
    add_index :exams, :category_id
  end
end
