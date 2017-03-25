class AddMongoIdToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :mongo_id, :string, :unique => true
  end
end
