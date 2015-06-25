class ChangePeselToString < ActiveRecord::Migration
  def change
    remove_column :entities, :pesel
    add_column :entities, :pesel, :string
  end
end
