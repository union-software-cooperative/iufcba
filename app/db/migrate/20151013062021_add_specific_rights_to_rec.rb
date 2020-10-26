class AddSpecificRightsToRec < ActiveRecord::Migration
  def change
    add_column :recs, :specific_rights, :boolean
    add_column :recs, :specific_rights_clause, :text
  end
end
