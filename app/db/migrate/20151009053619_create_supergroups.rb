class CreateSupergroups < ActiveRecord::Migration
  def change
    create_table :supergroups do |t|
      t.string :name
      t.string :type
      t.string :www

      t.timestamps null: false
    end
  end
end
