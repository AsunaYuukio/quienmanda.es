class AddImportedAtToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :imported_at, :datetime
  end
end
