class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :firstname
      t.string :lastname
      t.string :title
      t.text :address
      t.string :mobile
      t.string :fax
      t.string :email

      t.timestamps null: false
    end
  end
end
