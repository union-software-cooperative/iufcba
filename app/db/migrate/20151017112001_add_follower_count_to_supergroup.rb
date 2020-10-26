class AddFollowerCountToSupergroup < ActiveRecord::Migration
  def change
    add_column :supergroups, :followers_count, :integer, default: 0
  end
end
