class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :exam_id, :null => false
      t.string :title, :null => false

      t.timestamps
    end
    add_index :sections, :exam_id
  end
end
