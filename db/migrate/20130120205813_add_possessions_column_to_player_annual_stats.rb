class AddPossessionsColumnToPlayerAnnualStats < ActiveRecord::Migration
  def change
    add_column :player_annual_stats, :possessions, :string
    add_column :player_annual_stats, :opp_possessions, :string
  end
end
