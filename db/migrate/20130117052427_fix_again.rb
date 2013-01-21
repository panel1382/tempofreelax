class FixAgain < ActiveRecord::Migration
  def change
    rename_column :player_game_stats, :faceoff_wins, :faceoffs_won
    rename_column :player_game_stats, :penalty_seconds, :penalty_time
  end
end
