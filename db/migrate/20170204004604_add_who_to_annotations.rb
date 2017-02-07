class AddWhoToAnnotations < ActiveRecord::Migration
  def change
  	add_column :annotations, :user, :string, :default => "sovereign"
  end
end
