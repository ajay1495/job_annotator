class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skillsets do |t|
      # Relations
      t.integer :job_id
      t.integer :user_id

  	  t.string  :annotated_job_description, :default => ""

  	  t.string  :skills, :default => ""
  	  t.string  :optional_skills, :default => ""

      t.boolean :is_gold, :default => false 

      t.timestamps null: false
    end

    add_column :users, :is_gold_annotator, :boolean, :default => false
    remove_column :users, :skills_progress
  end
end
