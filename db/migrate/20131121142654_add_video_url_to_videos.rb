class AddVideoUrlToVideos < ActiveRecord::Migration
  def up
    add_column :videos, :video_url, :string
  end

  def down
    remove_column :videos, :video_url
  end
end
