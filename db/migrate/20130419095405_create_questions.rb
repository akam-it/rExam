class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :type_id, :null => false
      t.integer :section_id
      t.string  :title, :null => false
      t.integer :difficult, :null => false, :default => 5
      t.boolean :allow_mix, :null => false, :default => true
      t.string  :explanation

      t.timestamps
    end
    add_index :questions, :type_id
#    add_index :questions, :exam_id
    add_index :questions, :section_id
  end
end
