class CreatePlayerGameStats < ActiveRecord::Migration
  def change
    create_table :player_game_stats do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :goals
      t.integer :assists
      t.integer :shots
      t.integer :shots_on_goal
      t.integer :ground_balls
      t.integer :turnovers
      t.integer :caused_turnovers
      t.integer :faceoff_wins
      t.integer :faceoffs_taken
      t.integer :penalties
      t.integer :penalty_seconds
      t.integer :goalie_seconds
      t.integer :goals_allowed
      t.integer :saves
      t.integer :wins
      t.integer :losses
      t.integer :ties

      t.timestamps
    end
  end
end
