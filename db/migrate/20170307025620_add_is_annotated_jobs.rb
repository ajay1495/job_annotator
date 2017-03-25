class AddIsAnnotatedJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :is_description_annotated, :boolean
  end
end
