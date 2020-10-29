class AddBannerAndLogoToSupergroup < ActiveRecord::Migration
  def change
    add_column :supergroups, :banner, :string
    add_column :supergroups, :logo, :string
  end
end
