class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string  :title
      t.string  :company_name
      t.string  :job_id
      t.string  :description

      t.timestamps null: false
    end
  end
end
