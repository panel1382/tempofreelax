class CreateAnnualStats < ActiveRecord::Migration
  def change
    create_table :annual_stats do |t|
      t.integer :team_id
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
      t.float :def_adj
      t.float :off_adj
      t.integer :conference_id

      t.timestamps
    end
  end
end
