class CreateReviews < ActiveRecord::Migration
  def up
    create_table :reviews do |t|
      t.references :user
      t.references :video
      t.text :content
      t.integer :rating

      t.timestamps
    end
  end

  def down
    drop_table :reviews
  end
end
