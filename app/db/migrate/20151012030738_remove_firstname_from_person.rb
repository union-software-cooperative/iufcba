class RemoveFirstnameFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :firstname, :string
  end
end
