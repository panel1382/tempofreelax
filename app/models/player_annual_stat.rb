class PlayerAnnualStat < ActiveRecord::Base
  require 'date'
  attr_accessible :assists, :caused_turnovers, :extra_man_goals, :faceoffs_won, :faceoffs_taken, :game_id, :goalie_seconds, :goals, :goals_allowed, :ground_balls, :losses, :man_down_goals, :penalties, :penalty_time, :player_id, :saves, :shot_attempts, :shots_on_goal, :team_id, :ties, :turnovers, :wins, :year, :possessions, :opp_possessions, :position, :faceoff_specialist
  
  belongs_to :player
  belongs_to :team
  
  @@defender_ratio = 3
  @@goalie_threshold = 600
  @@faceoff_threshold = 20
  
  def self.sumAll(year)
    range = Date.new(year,1,1)..Date.new(year,12,31)
    
    pgs = PlayerGameStat.joins(:player, :game).where('games.date' => range).select(:player_id).uniq
    pgs.each do |t|
      stat = PlayerAnnualStat.find_or_create_by_player_id_and_year(:player_id => t.player_id, :year => Date.new(year,1,1))
      stat.sum
      puts t.player_id
    end
  end
  
  def keys_for_sum
    [:assists, :caused_turnovers, :extra_man_goals, :faceoffs_won, :faceoffs_taken, 
    :goalie_seconds, :goals, :goals_allowed, :ground_balls, :losses, :man_down_goals, 
    :penalties, :penalty_time, :saves, :shot_attempts, :shots_on_goal, :ties, 
    :turnovers, :wins, :possessions, :opp_possessions]
  end
  
  def empty_hash
    h={}
    keys_for_sum.each {|key| h[key] = 0}
    h
  end
  
  def guess_position
    if goalie_seconds > @@goalie_threshold
      self.position = "Goalie"
    elsif (ground_balls.to_f / shot_attempts) > @@defender_ratio
      self.position = "Defense"
    else
      self.position = "Attack"
    end
    
    faceoffs_taken > @@faceoff_threshold ? self.faceoff_specialist = true : self.faceoff_specialist = false 
  end
  
  def sum
    range = (Date.new(year.year,1,1)..Date.new(year.year,12,31))
    games = PlayerGameStat.joins(:game).where(:player_id => player_id, 'games.date' => range)
    self.team_id = player.team_id
    hash = empty_hash
    games.each do |game|
      if game.game.home_team == team_id 
        us = :home 
        them = :away 
      else
        us = :away
        them = :home
      end
      keys_for_sum.each do |k|
        if k == :possessions
          hash[k] += game.game.possessions us
        elsif k == :opp_possessions
          hash[k] += game.game.possessions them
        else
          val = game.send k
          hash[k] += (game.send k) if !val.nil?
        end
      end
    end
    
    update_attributes hash
    guess_position
    save!
  end
  
  def active?
    if goals < 2 and assists < 2 and caused_turnovers < 5 and ground_balls < 10 and shot_attempts < 10
      false
    else
      true
    end
  end
  
  # stats
  def goals_per_possession
    (goals.to_f / possessions.to_i) 
  end
  
  def assists_per_possession
    (assists.to_f / possessions.to_i)
  end
  
  def turnovers_per_possession
    (turnovers.to_f / possessions.to_i)
  end
  
  def caused_turnovers_per_possession
    (caused_turnovers.to_f / opp_possessions.to_i)
  end
  
  def ground_balls_per_possession
    ground_balls.to_f / (possessions).to_i
  end
  
  def ground_balls_per_defensive_possession
    ground_balls.to_f / opp_possessions.to_i
  end
  
  def shots_per_possession
    shot_attempts.to_f / possessions.to_i
  end
  
  def shooting_percentage
    if shot_attempts.to_i > 0
      (shots_on_goal.to_f / shot_attempts)*100
    else
      0
    end
  end
  
  def goals_allowed_per_possesion
    goals_allowed.to_f / opp_possessions.to_i
  end
  
  def save_percentage
    (saves.to_f / (saves + goals_allowed))*100
  end
  
  def goalie_minutes
    minutes = (goalie_seconds.to_i / 60)
    seconds = goalie_seconds.to_i % 60
    "#{minutes}:#{seconds}"
  end
  
  def fo_percentage
    (faceoffs_won.to_f / faceoffs_taken.to_i)*100
  end
  
  def faceoffs_lost
    faceoffs_taken.to_i - faceoffs_won.to_i
  end 
  
  def turnovers_per_faceoff
    turnovers.to_f / faceoffs_taken.to_i
  end
  
end
