class AddSkillsProgress < ActiveRecord::Migration
  def change
  	add_column :users, :skills_progress, :integer, :default=>1
  end
end
