class AddOppPythToAnnualStats < ActiveRecord::Migration
  def change
    add_column :annual_stats, :opp_pyth, :float
  end
end
