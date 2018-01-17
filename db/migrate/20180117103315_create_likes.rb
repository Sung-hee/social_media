class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user
      t.references :post
      t.timestamps null: false
    end
  end
end
