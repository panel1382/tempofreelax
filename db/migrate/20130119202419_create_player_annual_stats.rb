class CreatePlayerAnnualStats < ActiveRecord::Migration
  def change
    create_table :player_annual_stats do |t|
      t.integer :assists
      t.integer :caused_turnovers
      t.integer :faceoff_wins
      t.integer :faceoffs_taken
      t.integer :game_id
      t.integer :goalie_seconds
      t.integer :goals
      t.integer :goals_allowed
      t.integer :ground_balls
      t.integer :losses
      t.integer :penalties
      t.integer :penalty_time
      t.integer :player_id
      t.integer :saves
      t.integer :shot_attempts
      t.integer :shots_on_goal
      t.integer :ties
      t.integer :turnovers
      t.integer :wins
      t.integer :extra_man_goals
      t.integer :man_down_goals
      t.date :year
      t.integer :team_id

      t.timestamps
    end
  end
end
