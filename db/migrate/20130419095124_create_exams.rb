class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :category_id, :null => false
      t.integer :vendor_id, :null => false
      t.string :title, :null => false
      t.string :number, :null => false
      t.string :version, :null => false, :default => "1"
      t.integer :pass_score, :null => false, :default => 600
      t.integer :time_limit, :null => false, :default => 120
      t.string :description

      t.timestamps
    end
    add_index :exams, [:category_id, :vendor_id]
  end
end
