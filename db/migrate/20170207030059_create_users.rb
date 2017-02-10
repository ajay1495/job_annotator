class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :email
      t.boolean :is_initialized 
      t.string  :digest      

      t.timestamps null: false
    end
  end
end
