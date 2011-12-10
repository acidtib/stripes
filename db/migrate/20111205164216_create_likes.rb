class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      
      t.references :user
      t.integer :media_id

      t.timestamps
    end
  end
end
