class CreateCategoriesVideos < ActiveRecord::Migration
  def up
    create_table :categories_videos do |t|
    t.references :category
    t.references :video

    t.timestamps
    end
  end

  def down
    drop_table :categories_videos
  end
end
