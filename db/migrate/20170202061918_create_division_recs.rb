class CreateDivisionRecs < ActiveRecord::Migration
  def change
    create_table :division_recs do |t|
      t.references :division, index: true, foreign_key: true
      t.references :rec, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
