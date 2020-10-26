class AddCountryToSupergroup < ActiveRecord::Migration
  def change
    add_column :supergroups, :country, :string
  end
end
