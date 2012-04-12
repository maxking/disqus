class CreateCommenters < ActiveRecord::Migration
  def change
    create_table :commenters do |t|
      t.integer :project_id
      t.string :codename
      t.string :email

      t.timestamps
    end
  end
end
