class CreateFollowships < ActiveRecord::Migration
  def self.up
    create_table :followships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    
    add_index :followships, :follower_id
    add_index :followships, :followed_id
    add_index :followships, [:follower_id, :followed_id], :unique => true
    
  end

  def self.down
    drop_table :followships
  end
end
