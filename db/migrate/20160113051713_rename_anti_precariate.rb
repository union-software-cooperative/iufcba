class RenameAntiPrecariate < ActiveRecord::Migration
  def change
    rename_column :recs, :anti_precariate_page, :anti_precariat_page
  end
end
