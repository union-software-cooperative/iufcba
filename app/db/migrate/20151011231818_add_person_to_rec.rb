class AddPersonToRec < ActiveRecord::Migration
  def change
    add_reference :recs, :person, index: true, foreign_key: true
  end
end
