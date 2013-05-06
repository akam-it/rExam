class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string  :session_id
      t.integer :user_id
      t.integer :exam_id
      t.integer :question_id
      t.integer :try
      t.string  :answer
      t.boolean :is_correct
      t.integer :score

    end
    add_index :results, :session_id
    add_index :results, :user_id
    add_index :results, :exam_id
    add_index :results, :question_id
    add_index :results, :try
    add_index :results, :is_correct
    add_index :results, :score
  end
end
