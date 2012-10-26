class CreateGameStats < ActiveRecord::Migration
  def change
    create_table :game_stats do |t|
      t.integer :team_id
      t.boolean :home
      t.integer :game_id
      t.integer :goals
      t.integer :shot_attempts
      t.integer :shots_on_goal
      t.integer :assists
      t.integer :faceoffs_won
      t.float :faceoff_percentage
      t.integer :clear_attempts
      t.integer :clear_success
      t.integer :extra_man_opportunities
      t.integer :extra_man_goals
      t.integer :man_down_goals
      t.integer :penalties

      t.timestamps
    end
  end
end
