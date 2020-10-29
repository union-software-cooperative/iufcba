class AddShortNameToSupergroup < ActiveRecord::Migration
  def change
    add_column :supergroups, :short_name, :string
  end
end
