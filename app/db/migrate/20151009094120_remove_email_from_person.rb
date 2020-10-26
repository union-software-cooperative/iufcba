class RemoveEmailFromPerson < ActiveRecord::Migration
  def change
  		remove_column :people, :email, :string
  end
end
