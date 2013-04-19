class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.string :title
      t.boolean :is_correct

      t.timestamps
    end
    add_index :answers, :question_id
    add_index :answers, :is_correct
  end
end
