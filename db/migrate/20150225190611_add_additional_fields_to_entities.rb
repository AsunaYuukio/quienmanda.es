class AddAdditionalFieldsToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :birth_date, :date
    add_column :entities, :occupation, :string
    add_column :entities, :attendance, :integer
    add_column :entities, :club_name, :string
  end
end
