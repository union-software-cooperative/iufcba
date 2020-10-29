class RemoveLastnameFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :lastname, :string
  end
end
