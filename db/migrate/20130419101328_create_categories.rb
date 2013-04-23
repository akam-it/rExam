class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, :null => false
      t.string :ancestry

      t.timestamps
    end
    add_index :categories, :ancestry
  end
end
