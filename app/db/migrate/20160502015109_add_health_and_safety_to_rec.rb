class AddHealthAndSafetyToRec < ActiveRecord::Migration
  def change
    add_column :recs, :health_and_safety, :boolean
    add_column :recs, :health_and_safety_page, :string
    add_column :recs, :health_and_safety_clause, :text
  end
end
