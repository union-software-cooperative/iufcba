class TranslateDivisions < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        # Data migration uses I18n.default_locale. 
        # Wrap this in an I18n.with_locale(:en) block to specify otherwise.
        Division.create_translation_table!({
          name: :string,
          short_name: :string
        }, {
          migrate_data: true,
          remove_source_columns: true
        })
      end
      
      dir.down do
        add_column :divisions, :name, :string
        add_column :divisions, :short_name, :string
        
        Division.drop_translation_table!(migrate_data: true)
      end
    end
  end
end
