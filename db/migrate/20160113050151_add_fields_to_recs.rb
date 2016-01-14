class AddFieldsToRecs < ActiveRecord::Migration
  def change
    add_column :recs, :grievance_handling_page, :integer
    add_column :recs, :union_mandate_page, :integer
    add_column :recs, :anti_precariate_page, :integer
    add_column :recs, :specific_rights_page, :integer
  end
end
