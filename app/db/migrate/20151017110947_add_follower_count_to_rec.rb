class AddFollowerCountToRec < ActiveRecord::Migration
  def change
    add_column :recs, :followers_count, :integer, default: 0
  end
end
