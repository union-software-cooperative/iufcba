class AddUnionToRec < ActiveRecord::Migration
  def change
    add_reference :recs, :union, index: true
  	add_foreign_key :recs, :supergroups, column: :union_id
  end
end
