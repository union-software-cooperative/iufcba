class RemoveProductServiceAndLocalUnionContactAndNationalUnionContactFromRec < ActiveRecord::Migration
  def change
    remove_column :recs, :product_service, :string
    remove_column :recs, :local_union_contact, :string
    remove_column :recs, :national_union_contact, :string
  end
end
