class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string :name
      t.string :short_name
      t.string :logo
      t.string :colour1
      t.string :colour2

      t.timestamps null: false
    end
  end
end
