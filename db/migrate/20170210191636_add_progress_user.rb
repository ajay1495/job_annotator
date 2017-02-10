class AddProgressUser < ActiveRecord::Migration
  def change
  	add_column :users, :progress, :integer, :default=>1
  	add_column :annotations, :personality, :string
  end
end
