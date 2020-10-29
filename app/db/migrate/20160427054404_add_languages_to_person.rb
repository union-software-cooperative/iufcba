class AddLanguagesToPerson < ActiveRecord::Migration
  def change
    add_column :people, :languages, :string
  end
end
