class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :tag
      t.integer :user_id
      t.string :image
      t.integer :total_time
      t.boolean :status

      t.timestamps null: false
    end
  end
end
