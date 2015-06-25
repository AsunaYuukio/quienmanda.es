class CreateImportBlacklists < ActiveRecord::Migration
  def change
    create_table :import_blacklists do |t|
      t.string :object_type
      t.string :object_name
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :import_blacklists, [:object_type, :object_name], :unique => true
  end
end
