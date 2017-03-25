class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      # Relations
      t.integer :job_id
      t.integer :user_id

  	  t.string  :annotated_job_description, :default => ""

  	  t.string  :skills, :default => ""
  	  t.string  :optional_skills, :default => ""

      t.timestamps null: false
    end
  end
end
