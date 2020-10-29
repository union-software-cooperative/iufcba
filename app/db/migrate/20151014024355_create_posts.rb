class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.string :attachment
      t.belongs_to :person, index: true, foreign_key: true
      t.references :parent, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_index :posts, :parent_id
  end
end
