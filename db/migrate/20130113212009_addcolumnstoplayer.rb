class Addcolumnstoplayer < ActiveRecord::Migration
  def change
    add_column :players, :first_name, :string
    add_column :players, :last_name, :string
    remove_column :players, :name
  end
end
