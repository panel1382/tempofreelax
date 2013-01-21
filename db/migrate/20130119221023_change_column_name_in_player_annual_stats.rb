class ChangeColumnNameInPlayerAnnualStats < ActiveRecord::Migration
  def change
    rename_column :player_annual_stats, :faceoff_wins, :faceoffs_won
  end
end
