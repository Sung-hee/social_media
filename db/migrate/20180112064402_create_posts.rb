class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :tag
      t.string :post_image
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
