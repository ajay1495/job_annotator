class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.integer :job_id
	  t.integer :min_tenure
	  t.integer :max_tenure, :default => 216

	  t.string  :skills
	  t.string  :optional_skills
	  t.string  :education_level
	  t.string  :degree_major 
	  t.string  :work_area 
	  t.string  :work_type # Like, fulltime or parttime

      t.timestamps null: false
    end
  end
end
