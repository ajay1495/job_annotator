class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      # Relations
      t.integer :job_id
      t.integer :user_id


	  t.integer :min_tenure, :default => 0
	  t.integer :max_tenure, :default => 216

	  t.string  :skills, :default => ""
	  t.string  :optional_skills, :default => ""
	  t.string  :education_level, :default => ""
	  t.string  :degree_major, :default => "" 
	  t.string  :work_area, :default => "" 
	  t.string  :work_type, :default => ""

      t.timestamps null: false
    end
  end
end
