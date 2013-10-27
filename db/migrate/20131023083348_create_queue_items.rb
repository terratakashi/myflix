class CreateQueueItems < ActiveRecord::Migration
  def up
    create_table :queue_items do |t|
      t.integer :position
      t.references :user
      t.references :video

      t.timestamps
    end
  end

  def down
    drop_table :queue_items
  end
end
