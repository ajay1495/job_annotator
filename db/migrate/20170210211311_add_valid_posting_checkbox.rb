class AddValidPostingCheckbox < ActiveRecord::Migration
  def change
  	add_column :annotations, :valid_posting, :boolean, default: true
  end
end
