class AddAccuracy < ActiveRecord::Migration
  def change
	add_column :users, :skills_accuracy, :decimal, :default=>0.0
  end
end
