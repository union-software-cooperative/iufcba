class AddNatureOfOperationToRec < ActiveRecord::Migration
  def change
    add_column :recs, :nature_of_operation, :string
  end
end
