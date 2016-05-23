class AddIndexToVotes < ActiveRecord::Migration
  def change
    add_index :votes, [:votable_id, :votable_type, :user_id]
  end
end
