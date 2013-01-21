class AddColumnsToPlayerGameStats < ActiveRecord::Migration
  def change
    add_column :player_game_stats, :man_down_goals, :integer
    add_column :player_game_stats, :extra_man_goals, :integer
  end
end
