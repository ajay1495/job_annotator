class AddTimeTakenToUser < ActiveRecord::Migration
  def change
  	add_column :users, :timetaken, :integer 
  	add_column :users, :othernotes, :string
  end
end
