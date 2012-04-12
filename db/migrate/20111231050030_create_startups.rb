class CreateStartups < ActiveRecord::Migration
  def change
    create_table :startups do |t|
			t.integer :project_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
