class AddPeselToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :pesel, :integer
  end
end
