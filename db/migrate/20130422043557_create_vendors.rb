class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :title

      t.timestamps
    end
  end
end
