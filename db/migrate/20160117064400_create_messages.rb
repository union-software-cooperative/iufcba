class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.string :display_name
      t.integer :person_id, null: false
      t.timestamps null: false
   	end
  	add_foreign_key :messages, :people
  end
end
