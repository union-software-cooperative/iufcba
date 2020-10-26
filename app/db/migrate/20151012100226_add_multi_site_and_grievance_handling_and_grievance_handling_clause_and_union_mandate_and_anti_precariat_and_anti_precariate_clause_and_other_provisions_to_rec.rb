class AddMultiSiteAndGrievanceHandlingAndGrievanceHandlingClauseAndUnionMandateAndAntiPrecariatAndAntiPrecariateClauseAndOtherProvisionsToRec < ActiveRecord::Migration
  def change
    add_column :recs, :multi_site, :boolean
    add_column :recs, :grievance_handling, :boolean
    add_column :recs, :grievance_handling_clause, :text
    add_column :recs, :union_mandate, :boolean
    add_column :recs, :union_mandate_clause, :text
    add_column :recs, :anti_precariat, :boolean
    add_column :recs, :anti_precariat_clause, :text
    add_column :recs, :other_provisions, :text
  end
end
