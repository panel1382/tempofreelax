class AddColumnToAnnualStats < ActiveRecord::Migration
  def change
    add_column :annual_stats, :penalties, :integer
    add_column :annual_stats, :opp_penalties, :integer    
  end
end
