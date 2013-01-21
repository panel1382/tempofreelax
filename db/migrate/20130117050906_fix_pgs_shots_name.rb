class FixPgsShotsName < ActiveRecord::Migration
  def up
    rename_column :player_game_stats, :shots, :shot_attempts
  end

  def down
    rename_column :player_game_stats, :shot_attempts, :shots
  end
end
