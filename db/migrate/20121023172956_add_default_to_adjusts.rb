class AddDefaultToAdjusts < ActiveRecord::Migration
  def change
    change_column_default :annual_stats, :def_adj, 1
    change_column_default :annual_stats, :off_adj, 1
  end
end
