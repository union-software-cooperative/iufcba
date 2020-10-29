class AddCompanyToRec < ActiveRecord::Migration
  def change
    add_reference :recs, :company, references: :supergroups, index: true
    add_foreign_key :recs, :supergroups, column: :company_id
  end
end
