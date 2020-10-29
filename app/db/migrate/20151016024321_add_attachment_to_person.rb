class AddAttachmentToPerson < ActiveRecord::Migration
  def change
    add_column :people, :attachment, :string
  end
end
