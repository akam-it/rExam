class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :title, :null => false

      t.timestamps
    end
  end
end
