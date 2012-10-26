class AddColumnToStats < ActiveRecord::Migration
  def change
    add_column :stats, :order, :string, :default => 'descending'
  end
end
