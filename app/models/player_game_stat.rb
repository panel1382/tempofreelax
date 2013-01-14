class PlayerGameStat < ActiveRecord::Base
  attr_accessible :assists, :caused_turnovers, :faceoff_wins, :faceoffs_taken, :game_id, :goalie_seconds, :goals, :goals_allowed, :ground_balls, :losses, :penalties, :penalty_seconds, :player_id, :saves, :shots, :shots_on_goal, :ties, :turnovers, :wins
  
  belongs_to :player
  belongs_to :game
  
  def self.there?(game_id, player_id)
    t = PlayerGameStat.where(:game_id => game_id, :player_id => player_id).first
    
    t.nil? ? nil : t
    
  end
end
