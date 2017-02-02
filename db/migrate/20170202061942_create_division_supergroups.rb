class CreateDivisionSupergroups < ActiveRecord::Migration
  def change
    create_table :division_supergroups do |t|
      t.references :division, index: true, foreign_key: true
      t.references :supergroup, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
