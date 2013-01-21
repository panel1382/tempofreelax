class PlayerGameStat < ActiveRecord::Base
  attr_accessible :assists, :caused_turnovers, :faceoffs_won, :faceoffs_taken, :game_id, :goalie_seconds, :goals, :goals_allowed, :ground_balls, :losses, :penalties, :penalty_time, :player_id, :saves, :shot_attempts, :shots_on_goal, :ties, :turnovers, :wins, :extra_man_goals, :man_down_goals
  
  belongs_to :player
  belongs_to :game
  
  def self.there?(game_id, player_id)
    t = PlayerGameStat.where(:game_id => game_id, :player_id => player_id).first
    t.nil? ? nil : t
  end
end