class AddIndexToGameStats < ActiveRecord::Migration
  def change
      add_index "game_stats", ["game_id", "team_id"], :unique => true
  end
end
