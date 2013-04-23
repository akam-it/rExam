class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id, :null => false
      t.string :title, :null => false
      t.boolean :is_correct, :null => false, :default => false

      t.timestamps
    end
    add_index :answers, :question_id
    add_index :answers, :is_correct
  end
end
