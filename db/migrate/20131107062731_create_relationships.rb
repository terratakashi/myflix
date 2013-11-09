class CreateRelationships < ActiveRecord::Migration
  def up
    create_table :relationships do |t|
      t.references :leader
      t.references :follower

      t.timestamps
    end
  end

  def down
    drop_table :relationships
  end
end
