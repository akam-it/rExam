class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :type_id
      t.integer :exam_id
      t.integer :section_id
      t.string :title
      t.integer :difficult
      t.boolean :allow_mix
      t.string :explanation

      t.timestamps
    end
    add_index :questions, :type_id
    add_index :questions, :exam_id
    add_index :questions, :section_id
  end
end
