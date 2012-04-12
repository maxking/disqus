class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :startup_id
      t.integer :commenter_id
      t.string :from
      t.text :message
      t.string :status

      t.timestamps
    end
  end
end
