class RemoveIndexRepliesPostId < ActiveRecord::Migration
  def change
    remove_index :replies, :post_id
  end
end
