class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :exam_id
      t.string :title

      t.timestamps
    end
    add_index :sections, :exam_id
  end
end
