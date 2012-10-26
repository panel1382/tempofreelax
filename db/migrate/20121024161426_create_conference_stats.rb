class CreateConferenceStats < ActiveRecord::Migration
  def change
    create_table :conference_stats do |t|
      t.integer :team_id
      t.integer :conference_id
      t.integer :as_id
      t.integer :rank_id
      t.date :year
      t.integer :games
      t.integer :wins
      t.integer :goals
      t.integer :shot_attempts
      t.integer :shots_on_goal
      t.integer :assists
      t.integer :faceoffs_won
      t.integer :opp_faceoffs_won
      t.integer :clear_attempts
      t.integer :clear_success
      t.integer :extra_man_opportunities
      t.integer :extra_man_goals
      t.integer :opp_extra_man_opportunities
      t.integer :man_down_goals
      t.integer :opp_goals
      t.integer :opp_shot_attempts
      t.integer :opp_shots_on_goal
      t.integer :opp_assists
      t.integer :opp_extra_man_goals
      t.integer :opp_clear_attempts
      t.integer :opp_clear_success
      t.integer :opp_man_down_goals
      t.decimal :def_adj
      t.decimal :off_adj
      t.integer :conference_id
      t.integer :ground_balls
      t.integer :opp_ground_balls
      t.integer :turnovers
      t.integer :opp_turnovers
      t.integer :caused_turnovers
      t.integer :opp_caused_turnovers

      t.timestamps
    end
  end
end
