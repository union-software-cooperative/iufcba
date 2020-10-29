class AddTakingActionToRec < ActiveRecord::Migration
  def change
    add_column :recs, :taking_action, :boolean
  end
end
