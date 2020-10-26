class ChangePageColumnsOnRecs < ActiveRecord::Migration
  def change
  	change_column :recs, :grievance_handling_page, :string
    change_column :recs, :union_mandate_page, :string
    change_column :recs, :anti_precariat_page, :string
    change_column :recs, :specific_rights_page, :string
  end
end
