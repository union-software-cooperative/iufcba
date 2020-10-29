class CreateRecs < ActiveRecord::Migration
  def change
    create_table :recs do |t|
      t.string :name
      t.string :tags
      t.date :start_date
      t.date :end_date
      t.string :attachment
      t.string :coverage
      t.string :product_service
      t.string :union
      t.string :company
      t.string :local_union_contact
      t.string :national_union_contact

      t.timestamps null: false
    end
  end
end
